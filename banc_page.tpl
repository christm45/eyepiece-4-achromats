<!doctype html>
<html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Banc de mesure de focale - 3D</title>
<style>
:root{--bg:#10151c;--pan:#171e28;--ln:#2a3544;--tx:#dbe4ef;--mu:#8fa0b5;--ac:#4aa3ff;--ok:#5ed39a;--wa:#ffb454;--bad:#ff7a7a}
*{box-sizing:border-box}html,body{margin:0;height:100%;background:var(--bg);color:var(--tx);font:14px/1.45 system-ui,Segoe UI,sans-serif}
#app{display:grid;grid-template-columns:minmax(0,1fr) 420px;height:100vh}
#view{position:relative;min-width:0}#cv{width:100%;height:100%;display:block}
#hud{position:absolute;left:12px;top:10px;display:flex;flex-wrap:wrap;gap:6px;max-width:calc(100% - 130px)}
.chip{background:#0c1117cc;border:1px solid var(--ln);border-radius:8px;padding:5px 9px;font-size:12px;color:var(--mu)}.chip b{color:var(--tx);font-weight:600}
#parts{position:absolute;left:12px;bottom:12px;background:#0c1117d9;border:1px solid var(--ln);border-radius:10px;padding:8px 10px;font-size:12px}
#parts label{display:flex;align-items:center;gap:7px;padding:1px 0;cursor:pointer}#parts i{width:11px;height:11px;border-radius:3px;display:inline-block}
#side{background:var(--pan);border-left:1px solid var(--ln);overflow:auto;padding:14px 16px 40px}
h1{font-size:16px;margin:0 0 2px}h2{font-size:13px;margin:18px 0 8px;color:var(--ac);text-transform:uppercase;letter-spacing:.06em}
p{margin:6px 0}.mu{color:var(--mu)}.note{font-size:12px;color:var(--mu)}.nav a{color:var(--ac)}
.row{display:grid;grid-template-columns:132px 1fr 62px;gap:8px;align-items:center;margin:3px 0}
.row span{font-size:12px;color:var(--mu)}.row output{font-size:12px;text-align:right;font-variant-numeric:tabular-nums}
input[type=range]{width:100%;accent-color:var(--ac)}
select,input[type=number]{background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px;width:100%}
.kpi{display:grid;grid-template-columns:repeat(3,1fr);gap:6px;margin:10px 0}.kpi div{background:#0f151d;border:1px solid var(--ln);border-radius:8px;padding:6px 8px}
.kpi small{display:block;color:var(--mu);font-size:11px}.kpi b{font-size:17px;font-variant-numeric:tabular-nums}
#lang{position:absolute;right:12px;top:10px;display:flex;z-index:2}#lang button{background:#0c1117cc;color:var(--mu);border:1px solid var(--ln);padding:5px 10px;font-size:12px;cursor:pointer}#lang button:first-child{border-radius:8px 0 0 8px}#lang button:last-child{border-radius:0 8px 8px 0;border-left:0}#lang button.on{color:var(--tx);border-color:var(--ac);background:#16324f}
.vb{background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:5px 10px;cursor:pointer;font-size:12px}.vb:hover{border-color:var(--ac)}
.warn{border-left:3px solid var(--wa);background:#241d10;padding:7px 10px;border-radius:0 8px 8px 0;font-size:12.5px;margin:10px 0}
.card{background:#0f151d;border:1px solid var(--ln);border-radius:10px;padding:9px 12px;margin:8px 0;font-size:13px}.card b{color:var(--ac)}
.good{color:var(--ok)}.bad{color:var(--bad)}
@media(max-width:900px){#app{grid-template-columns:1fr;grid-template-rows:55vh auto;height:auto}#side{border-left:0}}
</style></head><body>
<div id="app">
 <div id="view"><canvas id="cv"></canvas><div id="hud"></div><div id="lang"><button data-l="fr">FR</button><button data-l="en">EN</button></div><div id="parts"></div></div>
 <div id="side">
  <h1>Banc de mesure de focale des achromats</h1>
  <p class="note nav">→ <a href="oculaire_3D.html">Oculaire 4 achromats (les focales mesurées s'y entrent)</a></p>
  <p class="mu">Rail gradué 0–305 mm, chariot porte-lentille (Ø50 / Ø40 / Ø30), chariot écran. Source lointaine (≥ 2 m). Simulez une mesure : déplacez l'écran jusqu'à l'image nette.</p>

  <h2>Lentille à mesurer (simulation)</h2>
  <div class="row"><span>Diamètre</span><select id="dia" style="grid-column:2/4"><option value="50">Ø50 (jumelles 7x50, 8x50, 10x50)</option><option value="40" selected>Ø40 (8x40)</option><option value="30">Ø30 (8x30)</option></select></div>
  <div class="row"><span>Focale réelle (inconnue)</span><input id="f" type="range" min="80" max="280" step="1" value="160"><output id="fo"></output></div>
  <div class="row"><span>Épaisseur (mm)</span><input id="t" type="range" min="4" max="14" step="0.5" value="8"><output id="to"></output></div>
  <div class="row"><span>Distance source u (mm)</span><input id="u" type="range" min="2000" max="10000" step="100" value="3000"><output id="uo"></output></div>

  <h2>Positions sur le rail (ce que vous lisez)</h2>
  <div class="row"><span>Lecture chariot lentille</span><input id="rl" type="range" min="30" max="260" step="0.5" value="60"><output id="rlo"></output></div>
  <div class="row"><span>Lecture chariot écran</span><input id="re" type="range" min="80" max="298" step="0.5" value="225"><output id="reo"></output></div>
  <div style="display:flex;gap:8px;margin:8px 0;flex-wrap:wrap"><button class="vb" id="af">Mettre au point (écran sur l'image)</button><button class="vb" id="rd">Vue rail</button><button class="vb" id="rv">Vue 3/4</button><button class="vb" id="sv">Vue source</button></div>
  <div class="kpi" id="kpi"></div>
  <p class="note" id="msg"></p>

  <h2>Source LED et masque (simulation)</h2>
  <div class="row"><span>LED</span><label style="grid-column:2/4"><input type="checkbox" id="led" checked> allumée</label></div>
  <div class="row"><span>Couleur</span><select id="lc" style="grid-column:2/4"><option value="white" selected>blanche</option><option value="red">rouge</option><option value="green">verte</option><option value="amber">ambre</option></select></div>
  <div class="row"><span>Masque</span><select id="mt" style="grid-column:2/4"><option value="pin" selected>trou d'épingle</option><option value="cross">croix</option><option value="none">aucun (LED nue Ø5)</option></select></div>
  <div class="row"><span>Taille du masque (mm)</span><input id="ms" type="range" min="0.2" max="3" step="0.1" value="0.5"><output id="mso"></output></div>
  <div class="kpi" id="lk"></div>
  <p class="note" id="lmsg"></p>

  <h2>Calculer la focale de VOTRE lentille</h2>
  <div class="row"><span>Diamètre</span><select id="cd" style="grid-column:2/4"><option value="50">Ø50</option><option value="40" selected>Ø40</option><option value="30">Ø30</option></select></div>
  <div class="row"><span>Lecture chariot lentille</span><input id="cl" type="number" step="0.5" value="60" style="grid-column:2/4"></div>
  <div class="row"><span>Lecture chariot écran</span><input id="ce" type="number" step="0.5" value="225" style="grid-column:2/4"></div>
  <div class="row"><span>u source → lentille (mm)</span><input id="cu" type="number" step="10" value="3000" style="grid-column:2/4"></div>
  <div class="row"><span>Épaisseur lentille (mm)</span><input id="ct" type="number" step="0.5" value="8" style="grid-column:2/4"></div>
  <div class="kpi" id="ck"></div>

  <h2>Méthode</h2>
  <div class="card"><b>1.</b> Posez la lentille dans le logement étagé <i>depuis l'avant</i> (côté source) : Ø50 sur l'épaulement 1, Ø40 sur le 2, Ø30 sur le 3 ; serrez par la tranche (vis nylon M3).</div>
  <div class="card"><b>2.</b> Visez une source lointaine (≥ 2 m) très contrastée, sur l'axe. Notez la lecture du chariot lentille (trait sous le fil repère de la fenêtre de lecture ; les chiffres sont tous les 10 mm).</div>
  <div class="card"><b>3.</b> Déplacez le chariot écran jusqu'au plus petit point net sur le calque. Notez sa lecture.</div>
  <div class="card"><b>4.</b> Mesurez u au mètre ruban jusqu'au montant du chariot. Entrez les 4 valeurs ci-dessus : f = u·v ÷ (u + v).</div>
  <div class="warn">Précision : ±0,5 mm par lecture, soit f à ±1 mm. Mesurez deux fois, lentille retournée, et faites la moyenne. Focales jusqu'à ~280 mm sur 305 mm de rail.</div>
 </div>
</div>
<script>__THREE__</script>
<script>__ORBIT__</script>
<script>__ROOMENV__</script>
<script>
const TITLE_EN = "Focal-length test bench - 3D";
const DICT = [
["Source LED et masque (simulation)","LED source and mask (simulation)"],["LED","LED"],["allumée","on"],["Couleur","Colour"],["blanche","white"],["rouge","red"],["verte","green"],["ambre","amber"],
["Masque","Mask"],["trou d'épingle","pinhole"],["croix","cross"],["aucun (LED nue Ø5)","none (bare Ø5 LED)"],["Taille du masque (mm)","Mask size (mm)"],["Vue source","Source view"],
["Oculaire 4 achromats (les focales mesurées s'y entrent)","4-achromat eyepiece (enter the measured focal lengths there)"],
["Banc de mesure de focale des achromats","Achromat focal-length test bench"],
["Rail gradué 0–305 mm, chariot porte-lentille (Ø50 / Ø40 / Ø30), chariot écran. Source lointaine (≥ 2 m). Simulez une mesure : déplacez l'écran jusqu'à l'image nette.","0–305 mm graduated rail, lens carriage (Ø50 / Ø40 / Ø30), screen carriage. Distant source (≥ 2 m). Simulate a measurement: move the screen until the image is sharp."],
["Lentille à mesurer (simulation)","Lens to measure (simulation)"],
["Diamètre","Diameter"],
["Ø50 (jumelles 7x50, 8x50, 10x50)","Ø50 (binoculars 7x50, 8x50, 10x50)"],
["Focale réelle (inconnue)","Actual focal length (unknown)"],["Épaisseur (mm)","Thickness (mm)"],["Distance source u (mm)","Source distance u (mm)"],
["Positions sur le rail (ce que vous lisez)","Positions on the rail (what you read)"],
["Lecture chariot lentille","Lens carriage reading"],["Lecture chariot écran","Screen carriage reading"],
["Mettre au point (écran sur l'image)","Focus (screen on the image)"],["Vue rail","Rail view"],["Vue 3/4","3/4 view"],
["Calculer la focale de VOTRE lentille","Calculate YOUR lens's focal length"],
["u source → lentille (mm)","u source → lens (mm)"],["Épaisseur lentille (mm)","Lens thickness (mm)"],
["Méthode","Method"],
["<b>1.</b> Posez la lentille dans le logement étagé <i>depuis l'avant</i> (côté source) : Ø50 sur l'épaulement 1, Ø40 sur le 2, Ø30 sur le 3 ; serrez par la tranche (vis nylon M3).","<b>1.</b> Place the lens in the stepped seat <i>from the front</i> (source side): Ø50 on shoulder 1, Ø40 on 2, Ø30 on 3; clamp it by the edge (M3 nylon screw)."],
["<b>2.</b> Visez une source lointaine (≥ 2 m) très contrastée, sur l'axe. Notez la lecture du chariot lentille (trait sous le fil repère de la fenêtre de lecture ; les chiffres sont tous les 10 mm).","<b>2.</b> Aim at a high-contrast distant source (≥ 2 m), on axis. Note the lens carriage reading (mark under the hairline of the reading window; numbers every 10 mm)."],
["<b>3.</b> Déplacez le chariot écran jusqu'au plus petit point net sur le calque. Notez sa lecture.","<b>3.</b> Move the screen carriage until the smallest sharp spot appears on the tracing paper. Note its reading."],
["<b>4.</b> Mesurez u au mètre ruban jusqu'au montant du chariot. Entrez les 4 valeurs ci-dessus : f = u·v ÷ (u + v).","<b>4.</b> Measure u with a tape measure up to the carriage post. Enter the 4 values above: f = u·v ÷ (u + v)."],
["Précision : ±0,5 mm par lecture, soit f à ±1 mm. Mesurez deux fois, lentille retournée, et faites la moyenne. Focales jusqu'à ~280 mm sur 305 mm de rail.","Accuracy: ±0.5 mm per reading, i.e. f to ±1 mm. Measure twice, with the lens flipped, and average. Focal lengths up to ~280 mm on a 305 mm rail."],
["Rail A (segment avec queue d'aronde)","Rail A (dovetail segment)"],["Rail B (segment avec mortaise)","Rail B (mortise segment)"],
["Chariot porte-lentille","Lens carriage"],["Chariot écran (calque)","Screen carriage (tracing paper)"],["Support source LED + masque","LED source holder + mask"]
];
</script>
<script>__I18N__</script>
<script>
// WebGL indisponible : on l'explique au lieu de laisser une vue noire
(function () {
  let ok = false;
  try { const c = document.createElement("canvas"); ok = !!(c.getContext("webgl2") || c.getContext("webgl")); } catch (e) { }
  if (!ok) {
    document.getElementById("view").innerHTML = '<div style="padding:24px;color:#ffb454;max-width:520px;line-height:1.5"><b>WebGL est désactivé ou indisponible dans ce navigateur : la vue 3D ne peut pas s\'afficher.</b><br>Activez l\'accélération matérielle (Chrome : Paramètres → Système → « Utiliser l\'accélération matérielle ») ou essayez un autre navigateur (Chrome, Edge, Firefox récents).<br><br><b>WebGL is disabled or unavailable in this browser: the 3D view cannot be displayed.</b><br>Enable hardware acceleration (Chrome: Settings → System → “Use hardware acceleration”) or try another recent browser (Chrome, Edge, Firefox).</div>';
    throw new Error("WebGL indisponible");
  }
})();
const DATA = __DATA__, M = DATA.meta;
const $ = id => document.getElementById(id);
const dec = b64 => { const s = atob(b64), u = new Uint8Array(s.length); for (let i = 0; i < s.length; i++) u[i] = s.charCodeAt(i); return new Float32Array(u.buffer); };
const DIST = { 50: 11.5, 40: 8.5, 30: 5.5 }, DEPTH = { 50: 3, 40: 6, 30: 9 }, SCR_IDX = 8.0;
const fmt = (n, d = 1) => n.toFixed(d);

// ---------- scene ----------
const cv = $("cv"), renderer = new THREE.WebGLRenderer({ canvas: cv, antialias: true, preserveDrawingBuffer: true });
renderer.setPixelRatio(Math.min(devicePixelRatio, 2)); renderer.shadowMap.enabled = true; renderer.shadowMap.type = THREE.PCFSoftShadowMap;
renderer.outputEncoding = THREE.sRGBEncoding; renderer.toneMapping = THREE.ACESFilmicToneMapping; renderer.toneMappingExposure = 0.8; renderer.setClearColor(0x1b2330);
const scene = new THREE.Scene(), cam = new THREE.PerspectiveCamera(35, 1, 1, 4000);
const ctl = new THREE.OrbitControls(cam, cv); ctl.enableDamping = true;
const pmrem = new THREE.PMREMGenerator(renderer); scene.environment = pmrem.fromScene(new THREE.RoomEnvironment(), 0.04).texture;
scene.add(new THREE.HemisphereLight(0xffffff, 0x20262e, 0.25));
const dl = new THREE.DirectionalLight(0xffffff, 0.6); dl.position.set(150, 260, 180); dl.castShadow = true;
Object.assign(dl.shadow.camera, { left: -260, right: 260, top: 160, bottom: -160, far: 900 }); dl.shadow.mapSize.set(2048, 2048); dl.shadow.bias = -0.0004; scene.add(dl);
const dl2 = new THREE.DirectionalLight(0x88aaff, 0.3); dl2.position.set(-150, 60, -120); scene.add(dl2);
const floor = new THREE.Mesh(new THREE.PlaneGeometry(1400, 700), new THREE.MeshStandardMaterial({ color: 0x0b0f16, roughness: 0.6, metalness: 0.05 }));
floor.rotation.x = -Math.PI / 2; floor.position.set(150, -0.1, 0); floor.receiveShadow = true; scene.add(floor);

function smoothNormals(pos) {
  const nt = pos.length / 9, fn = new Float32Array(nt * 3), map = new Map();
  const key = i => Math.round(pos[i] * 50) + "," + Math.round(pos[i + 1] * 50) + "," + Math.round(pos[i + 2] * 50);
  for (let t = 0; t < nt; t++) {
    const o = t * 9, ax = pos[o + 3] - pos[o], ay = pos[o + 4] - pos[o + 1], az = pos[o + 5] - pos[o + 2], bx = pos[o + 6] - pos[o], by = pos[o + 7] - pos[o + 1], bz = pos[o + 8] - pos[o + 2];
    fn[t * 3] = ay * bz - az * by; fn[t * 3 + 1] = az * bx - ax * bz; fn[t * 3 + 2] = ax * by - ay * bx;
    for (let v = 0; v < 3; v++) { const k = key(o + v * 3); let a = map.get(k); if (!a) { a = []; map.set(k, a); } a.push(t); }
  }
  const out = new Float32Array(nt * 9), ct = Math.cos(40 * Math.PI / 180);
  for (let t = 0; t < nt; t++) {
    const sx = fn[t * 3], sy = fn[t * 3 + 1], sz = fn[t * 3 + 2], sl = Math.hypot(sx, sy, sz) || 1;
    for (let v = 0; v < 3; v++) {
      let nx = 0, ny = 0, nz = 0;
      for (const u of map.get(key(t * 9 + v * 3))) { const ux = fn[u * 3], uy = fn[u * 3 + 1], uz = fn[u * 3 + 2], ul = Math.hypot(ux, uy, uz) || 1; if ((sx * ux + sy * uy + sz * uz) / (sl * ul) > ct) { nx += ux; ny += uy; nz += uz; } }
      const nl = Math.hypot(nx, ny, nz) || 1; out[t * 9 + v * 3] = nx / nl; out[t * 9 + v * 3 + 1] = ny / nl; out[t * 9 + v * 3 + 2] = nz / nl;
    }
  }
  return out;
}
const PART = {};
DATA.parts.forEach(p => {
  const g = new THREE.BufferGeometry(), pa = dec(p.pos);
  g.setAttribute("position", new THREE.BufferAttribute(pa, 3)); g.setAttribute("normal", new THREE.BufferAttribute(smoothNormals(pa), 3));
  const rail = p.id.startsWith("1") || p.id.startsWith("2");
  const m = new THREE.MeshPhysicalMaterial({ color: p.color, roughness: rail ? 0.42 : 0.38, metalness: rail ? 0.55 : 0.08, clearcoat: rail ? 0.2 : 0.6, clearcoatRoughness: 0.35, envMapIntensity: 0.6, side: THREE.DoubleSide });
  const mesh = new THREE.Mesh(g, m); mesh.castShadow = mesh.receiveShadow = true; scene.add(mesh); PART[p.id] = { mesh, p };
});
const SRC_D = 150;      // distance lentille -> source DESSINEE (la vraie est u : 2 a 10 m, hors cadre)
const srcMat = PART["5_support_source"].mesh.material; srcMat.transparent = true; srcMat.opacity = 0.55;
const COLS = { white: 0xfff1d6, red: 0xff3b30, green: 0x38ff7a, amber: 0xffb000 };
const glowTex = (() => { const c = document.createElement("canvas"); c.width = c.height = 128; const g = c.getContext("2d"), r = g.createRadialGradient(64, 64, 0, 64, 64, 64);
  r.addColorStop(0, "rgba(255,255,255,1)"); r.addColorStop(0.25, "rgba(255,255,255,0.45)"); r.addColorStop(1, "rgba(255,255,255,0)"); g.fillStyle = r; g.fillRect(0, 0, 128, 128); return new THREE.CanvasTexture(c); })();
const srcLight = new THREE.PointLight(0xffffff, 0, 700); scene.add(srcLight);
let srcG = null, dimG = null;
function label(txt, col, w) {                 // etiquette 3D (sprite : reste face a la camera)
  const c = document.createElement("canvas"); c.width = 640; c.height = 140; const g = c.getContext("2d");
  g.fillStyle = "rgba(11,15,22,0.9)"; g.strokeStyle = col; g.lineWidth = 6;
  g.beginPath(); if (g.roundRect) g.roundRect(4, 4, 632, 132, 22); else g.rect(4, 4, 632, 132); g.fill(); g.stroke();
  g.fillStyle = col; g.font = "bold 62px system-ui,Segoe UI,sans-serif"; g.textAlign = "center"; g.textBaseline = "middle"; g.fillText(txt, 320, 72);
  const sp = new THREE.Sprite(new THREE.SpriteMaterial({ map: new THREE.CanvasTexture(c), transparent: true, depthTest: false }));
  sp.scale.set(w, w * 140 / 640, 1); sp.renderOrder = 10; return sp;
}
const RUL_L = 320, RUL_W = 18, RUL_PX = 8;     // reglette : longueur (mm), largeur (mm), pixels par mm de la texture
function rulerTex(f, v, fm) {                      // reglette graduee dont le zero est au plan principal de la lentille ; bande verte jusqu'a f, repere bleu a v
  const c = document.createElement("canvas"); c.width = RUL_L * RUL_PX; c.height = RUL_W * RUL_PX; const g = c.getContext("2d"), H = c.height;
  g.fillStyle = "#e9edf2"; g.fillRect(0, 0, c.width, H);
  g.fillStyle = "#5ed39a"; g.fillRect(0, H - 3.2 * RUL_PX, f * RUL_PX, 3.2 * RUL_PX);                 // longueur f
  g.fillStyle = "#4aa3ff"; g.fillRect(0, H - 6.0 * RUL_PX, v * RUL_PX, 2.0 * RUL_PX);                 // longueur v
  g.fillStyle = "#ff9f1c"; g.fillRect(fm * RUL_PX - 2, 0, 4, H - 3.2 * RUL_PX);                       // focale deduite des lectures (orange)
  g.fillStyle = "#111"; g.strokeStyle = "#111"; g.textAlign = "center"; g.textBaseline = "top"; g.font = "bold " + 3.4 * RUL_PX + "px system-ui,Segoe UI,sans-serif";
  for (let mm = 0; mm <= RUL_L; mm++) {
    const x = mm * RUL_PX + 1, L = mm % 10 === 0 ? 5.2 : mm % 5 === 0 ? 3.6 : 2.2;
    g.lineWidth = mm % 10 === 0 ? 3 : 1.6; g.beginPath(); g.moveTo(x, 0); g.lineTo(x, L * RUL_PX); g.stroke();
    if (mm % 20 === 0 && mm > 0) g.fillText(String(mm), x, 5.6 * RUL_PX);
  }
  g.strokeStyle = "#c0392b"; g.lineWidth = 5; g.beginPath(); g.moveTo(2, 0); g.lineTo(2, H); g.stroke();      // zero
  const t = new THREE.CanvasTexture(c); t.anisotropy = 8; return t;
}
$("parts").innerHTML = DATA.parts.map(p => `<label><input type="checkbox" data-id="${p.id}" checked><i style="background:#${p.color.toString(16).padStart(6, "0")}"></i>${p.name}</label>`).join("");
$("parts").addEventListener("change", e => { const q = PART[e.target.dataset.id]; if (q) q.mesh.visible = e.target.checked; });

// lentille biconvexe (axe = x rail), reconstruite a chaque changement
let lens = null, rays = null;
const lensGeo = (d, t) => {
  const R = d / 2, s = Math.min(1.8 * d / 40, (t - 1) / 2), te = t - 2 * s, N = 28, pts = [];
  for (let i = 0; i <= N; i++) { const r = R * i / N; pts.push(new THREE.Vector2(r, -(te / 2 + s * (1 - (r / R) ** 2)))); }
  for (let i = N; i >= 0; i--) { const r = R * i / N; pts.push(new THREE.Vector2(r, te / 2 + s * (1 - (r / R) ** 2))); }
  return new THREE.LatheGeometry(pts, 64);
};
const glass = new THREE.MeshPhysicalMaterial({ color: 0xdff0ff, metalness: 0, roughness: 0.03, transmission: 0.7, thickness: 6, ior: 1.52, clearcoat: 1, envMapIntensity: 1.5, side: THREE.DoubleSide, transparent: true, opacity: 0.85 });

// ---------- physique ----------
function state() {
  const d = +$("dia").value, f = +$("f").value, t = +$("t").value, u = +$("u").value, rl = +$("rl").value, re = +$("re").value;
  const carL = rl - M.idxL;                                   // x du chariot lentille (origine = plan du montant)
  const xBack = carL - M.post / 2 + DEPTH[d];                 // face arriere de la lentille
  const xc = xBack - t / 2;                                   // centre de la lentille (plan principal suppose)
  const carS = re - SCR_IDX, xs = carS;                       // plan du papier = origine du chariot ecran
  const v = u * f / (u - f), xi = xc + v;                     // image
  const hAp = d / 2 * 0.9, blur = hAp * Math.abs(xs - xi) / v * 2;   // diametre du disque flou sur l'ecran
  // focale deduite des lectures (meme methode que mesure_focale.py)
  const sommet = rl - DIST[d], bfd = (re - SCR_IDX) - sommet, vm = bfd + t / 2, fm = u * vm / (u + vm);
  return { d, f, t, u, rl, re, carL, xc, carS, xs, v, xi, blur, hAp, fm, vm };
}
function draw() {
  const s = state();
  $("fo").textContent = s.f; $("to").textContent = s.t; $("uo").textContent = s.u; $("rlo").textContent = s.rl; $("reo").textContent = s.re;
  PART["3_chariot_lentille"].mesh.position.x = s.carL; PART["4_chariot_ecran"].mesh.position.x = s.carS;
  if (lens) { scene.remove(lens); lens.geometry.dispose(); }
  lens = new THREE.Mesh(lensGeo(s.d, s.t), glass); lens.rotation.z = -Math.PI / 2; lens.position.set(s.xc, M.zax, 0); scene.add(lens);
  const on = $("led").checked, col = COLS[$("lc").value], mt = $("mt").value, ms = +$("ms").value;
  const hx = s.xc - SRC_D, xm = hx + M.maskX, zA = M.zax;
  PART["5_support_source"].mesh.position.x = hx;
  if (srcG) { scene.remove(srcG); srcG.traverse(o => { o.geometry && o.geometry.dispose(); }); }
  srcG = new THREE.Group();
  const emi = new THREE.MeshStandardMaterial({ color: on ? col : 0x888888, emissive: on ? col : 0x000000, emissiveIntensity: on ? 1.6 : 0, transparent: true, opacity: on ? 0.95 : 0.6, roughness: 0.3 });
  const body = new THREE.Mesh(new THREE.CylinderGeometry(2.5, 2.5, 6.1, 32), emi); body.rotation.z = -Math.PI / 2; body.position.set(hx + M.ledSeat + 3.05, zA, 0); srcG.add(body);
  const dome = new THREE.Mesh(new THREE.SphereGeometry(2.5, 32, 16, 0, 2 * Math.PI, 0, Math.PI / 2), emi); dome.rotation.z = -Math.PI / 2; dome.position.set(hx + M.ledSeat + 6.1, zA, 0); srcG.add(dome);
  const fl = new THREE.Mesh(new THREE.CylinderGeometry(2.9, 2.9, 1.0, 32), emi); fl.rotation.z = -Math.PI / 2; fl.position.set(hx + M.ledSeat + 0.5, zA, 0); srcG.add(fl);
  const size = mt === "none" ? 5 : ms;                                    // taille de la source vue par la lentille
  if (mt !== "none") {                                                    // feuille d'alu percee dans la fente du masque
    const sh = new THREE.Shape(); sh.moveTo(-17.9, 14); sh.lineTo(17.9, 14); sh.lineTo(17.9, M.zax + 16); sh.lineTo(-17.9, M.zax + 16); sh.closePath();
    const hole = new THREE.Path();
    if (mt === "pin") hole.absarc(0, zA, ms / 2, 0, 2 * Math.PI, true);
    else { const a = ms / 2, w = Math.max(0.1, ms / 16); [[w, a], [w, w], [a, w], [a, -w], [w, -w], [w, -a], [-w, -a], [-w, -w], [-a, -w], [-a, w], [-w, w], [-w, a]].forEach(([x, y], i) => i ? hole.lineTo(x, zA + y) : hole.moveTo(x, zA + y)); hole.closePath(); }
    sh.holes.push(hole);
    const foil = new THREE.Mesh(new THREE.ShapeGeometry(sh, 24), new THREE.MeshStandardMaterial({ color: 0xc4c9d2, metalness: 0.9, roughness: 0.35, side: THREE.DoubleSide }));
    foil.rotation.y = Math.PI / 2; foil.position.set(xm, 0, 0); srcG.add(foil);
  }
  if (on) {
    const gl = new THREE.Sprite(new THREE.SpriteMaterial({ map: glowTex, color: col, blending: THREE.AdditiveBlending, transparent: true, depthWrite: false }));
    gl.scale.set(18, 18, 1); gl.position.set(xm + 0.4, zA, 0); srcG.add(gl);
    const cone = (x0, r0, x1, r1) => { const m = new THREE.Mesh(new THREE.CylinderGeometry(r1, r0, x1 - x0, 48, 1, true), new THREE.MeshBasicMaterial({ color: col, transparent: true, opacity: 0.09, blending: THREE.AdditiveBlending, depthWrite: false, side: THREE.DoubleSide }));
      m.rotation.z = -Math.PI / 2; m.position.set((x0 + x1) / 2, zA, 0); srcG.add(m); };
    cone(xm, size / 2, s.xc, s.hAp);                                      // source -> lentille
    const xe = Math.min(s.xs, s.xi);
    cone(s.xc, s.hAp, xe, s.hAp * (s.xi - xe) / s.v);                    // lentille -> image (ou ecran)
    if (s.xs > s.xi) cone(s.xi, 0.05, s.xs, s.hAp * (s.xs - s.xi) / s.v); // apres l'image : le faisceau diverge jusqu'a l'ecran
  }
  srcLight.color.setHex(col); srcLight.intensity = on ? 1.1 : 0; srcLight.position.set(xm + 10, zA, 0);
  scene.add(srcG);
  const imgD = size * s.v / s.u, spotD = Math.hypot(s.blur, imgD);
  if (rays) { scene.remove(rays); rays.traverse(o => o.geometry && o.geometry.dispose()); }
  rays = new THREE.Group();
  const x0 = s.xc - 120, x1 = Math.max(s.xs + 12, s.xi + 8);
  [[s.hAp, 0xff6b5a], [-s.hAp, 0xff6b5a], [s.hAp * 0.5, 0xffb454], [-s.hAp * 0.5, 0xffb454], [0, 0xffffff]].forEach(([h, col]) => {
    const pts = [], P = (x, y) => new THREE.Vector3(x, M.zax + y, 0);
    pts.push(P(xm, 0), P(s.xc, h));
    const slope = -h / s.v; pts.push(P(x1, h + slope * (x1 - s.xc)));
    rays.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(pts), new THREE.LineBasicMaterial({ color: col, transparent: true, opacity: 0.9 })));
  });
  const ok = spotD < 0.6;
  const spot = new THREE.Mesh(new THREE.CircleGeometry(Math.max(spotD / 2, 0.35), 48), new THREE.MeshBasicMaterial({ color: ok ? 0x5ed39a : 0xff5555, transparent: true, opacity: 0.85, side: THREE.DoubleSide }));
  spot.rotation.y = Math.PI / 2; spot.position.set(s.xs + 0.02, M.zax, 0); rays.add(spot);
  const foc = new THREE.Mesh(new THREE.SphereGeometry(0.9, 16, 12), new THREE.MeshBasicMaterial({ color: 0xffffff }));
  foc.position.set(s.xi, M.zax, 0); rays.add(foc);
  scene.add(rays);
  // reglette VOLANTE de la vraie focale : flotte a hauteur de l'axe optique, a cote du faisceau ; zero = plan principal de la lentille.
  // Bande verte = focale reelle de la lentille (curseur), repere orange = focale deduite des lectures, bande bleue = distance de l'image.
  if (dimG) { scene.remove(dimG); dimG.traverse(o => { o.geometry && o.geometry.dispose(); if (o.material && o.material.map) o.material.map.dispose(); }); }
  dimG = new THREE.Group();
  const ZR = 46, xF = s.xc + s.f, xM = s.xc + s.fm, xV = s.xc + s.v;
  const rul = new THREE.Mesh(new THREE.PlaneGeometry(RUL_L, RUL_W), new THREE.MeshBasicMaterial({ map: rulerTex(s.f, s.v, s.fm), side: THREE.DoubleSide }));
  rul.rotation.x = -Math.PI / 2; rul.position.set(s.xc + RUL_L / 2 - 1 / RUL_PX, M.zax, ZR); dimG.add(rul);
  const edge = new THREE.Mesh(new THREE.BoxGeometry(RUL_L + 2, 0.6, RUL_W + 2), new THREE.MeshStandardMaterial({ color: 0x20262e, metalness: 0.5, roughness: 0.5 })); edge.position.set(s.xc + RUL_L / 2, M.zax - 0.5, ZR); dimG.add(edge);
  const pin = (x, col, op) => dimG.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(x, M.zax, 0), new THREE.Vector3(x, M.zax, ZR - RUL_W / 2)]), new THREE.LineBasicMaterial({ color: col, transparent: true, opacity: op })));
  pin(s.xc, 0xc0392b, 0.7); pin(xF, 0x5ed39a, 0.9); pin(xV, 0x4aa3ff, 0.5);        // reports sur l'axe : lentille, foyer F, image
  const F = new THREE.Mesh(new THREE.SphereGeometry(1.6, 16, 12), new THREE.MeshBasicMaterial({ color: 0x5ed39a })); F.position.set(xF, M.zax, 0); dimG.add(F);
  const lf = label(tr("f réelle = " + fmt(s.f, 0) + " mm", "actual f = " + fmt(s.f, 0) + " mm"), "#5ed39a", 78); lf.position.set(xF, M.zax + 17, ZR); dimG.add(lf);
  const lm = label(tr("mesurée " + fmt(s.fm) + " mm", "measured " + fmt(s.fm) + " mm"), "#ff9f1c", 64); lm.position.set(xM, M.zax - 15, ZR); dimG.add(lm);
  const lv = label("v = " + fmt(s.v) + " mm", "#4aa3ff", 50); lv.position.set(xV, M.zax + 6, ZR - 18); dimG.add(lv);
  const l0 = label(tr("0 = lentille", "0 = lens"), "#e0705f", 50); l0.position.set(s.xc, M.zax + 6, ZR + 2); dimG.add(l0);
  scene.add(dimG);
  $("hud").innerHTML = LANG === "en"
    ? `<span class="chip">Lens reading <b>${fmt(s.rl)}</b> mm</span><span class="chip">Screen reading <b>${fmt(s.re)}</b> mm</span><span class="chip">Image <b>${fmt(s.xi - s.xc)}</b> mm from the lens</span><span class="chip">Spot <b>${fmt(spotD, 1)}</b> mm</span>`
    : `<span class="chip">Lecture lentille <b>${fmt(s.rl)}</b> mm</span><span class="chip">Lecture écran <b>${fmt(s.re)}</b> mm</span><span class="chip">Image à <b>${fmt(s.xi - s.xc)}</b> mm de la lentille</span><span class="chip">Tache <b>${fmt(spotD, 1)}</b> mm</span>`;
  const err = s.fm - s.f;
  $("kpi").innerHTML = `<div><small>${tr("Focale déduite", "Measured focal length")}</small><b>${fmt(s.fm)} mm</b></div><div><small>${tr("Écart vs réelle", "Error vs actual")}</small><b class="${Math.abs(err) < 1.5 ? "good" : "bad"}">${err >= 0 ? "+" : ""}${fmt(err)}</b></div><div><small>${tr("Tache sur l'écran", "Spot on screen")}</small><b class="${ok ? "good" : "bad"}">${fmt(spotD, 1)} mm</b></div>`;
  $("msg").innerHTML = ok ? tr("<b class='good'>Image nette</b> : la lecture de l'écran donne la bonne focale.", "<b class='good'>Sharp image</b>: the screen reading gives the right focal length.")
    : (s.xs < s.xi ? tr("L'écran est <b>avant</b> l'image : reculez-le.", "The screen is <b>in front of</b> the image: move it back.") : tr("L'écran est <b>après</b> l'image : avancez-le.", "The screen is <b>behind</b> the image: move it forward.")) + tr(" Si vous lisez ici, la focale déduite sera fausse.", " If you read here, the deduced focal length will be wrong.");
  if (s.xi + SCR_IDX > 298) $("msg").innerHTML = "<span class='bad'>" + tr("L'image tombe au-delà de la butée de l'écran (lecture " + fmt(s.xi + SCR_IDX, 0) + " mm &gt; 298) : reculez le chariot lentille (lecture plus faible) ou mesurez une source plus lointaine.", "The image falls beyond the screen's end stop (reading " + fmt(s.xi + SCR_IDX, 0) + " mm &gt; 298): move the lens carriage back (lower reading) or measure a more distant source.") + "</span>";
  const ang = size / s.u * 206265;
  $("lk").innerHTML = `<div><small>${tr("Taille de la source", "Source size")}</small><b>${fmt(size, 1)} mm</b></div><div><small>${tr("Vue depuis la lentille", "Seen from the lens")}</small><b>${fmt(ang, 0)}″</b></div><div><small>${tr("Image sur l'écran", "Image on the screen")}</small><b class="${imgD < 0.25 ? "good" : "bad"}">${fmt(imgD, 3)} mm</b></div>`;
  $("lmsg").innerHTML = mt === "none" ? tr("<b class='bad'>LED nue</b> : source de 5 mm, image de " + fmt(imgD, 2) + " mm sur l'écran. La mise au point est moins précise ; préférez un masque.", "<b class='bad'>Bare LED</b>: 5 mm source, " + fmt(imgD, 2) + " mm image on the screen. Focusing is less precise; use a mask.")
    : imgD < 0.25 ? tr("<b class='good'>Source ponctuelle</b> : l'image du masque (" + fmt(imgD, 3) + " mm) est négligeable devant la tache ; la mise au point est limitée par la lentille.", "<b class='good'>Point source</b>: the mask image (" + fmt(imgD, 3) + " mm) is negligible compared with the blur; focusing is limited by the lens.")
    : tr("<b class='bad'>Masque trop grand</b> : son image fait " + fmt(imgD, 2) + " mm sur l'écran. Réduisez le trou ou éloignez la source.", "<b class='bad'>Mask too large</b>: its image is " + fmt(imgD, 2) + " mm on the screen. Reduce the hole or move the source farther away.");
  $("lmsg").innerHTML += "<br>" + tr("Dessin hors échelle : la source est tracée à " + SRC_D + " mm de la lentille ; la vraie distance est u = " + s.u + " mm.", "Drawing not to scale: the source is drawn " + SRC_D + " mm from the lens; the real distance is u = " + s.u + " mm.");
  $("mso").textContent = fmt(ms, 1);
  calc();
}
function calc() {
  const d = +$("cd").value, rl = +$("cl").value, re = +$("ce").value, u = +$("cu").value, t = +$("ct").value;
  const sommet = rl - DIST[d], bfd = (re - SCR_IDX) - sommet, v = bfd + t / 2, f = u * v / (u + v);
  $("ck").innerHTML = `<div><small>${tr("BFD (sommet → écran)", "BFD (vertex → screen)")}</small><b>${fmt(bfd)}</b></div><div><small>${tr("v (plan princ. → écran)", "v (principal plane → screen)")}</small><b>${fmt(v)}</b></div><div><small>${tr("FOCALE f", "FOCAL LENGTH f")}</small><b class="good">${fmt(f)} mm</b></div>`;
}
["led", "lc", "mt", "ms"].forEach(id => $(id).addEventListener("input", draw));
["dia", "f", "t", "u", "rl", "re"].forEach(id => $(id).addEventListener("input", () => {
  if (id === "rl" && +$("re").value < +$("rl").value + 45) $("re").value = Math.min(298, +$("rl").value + 45);
  draw();
}));
["cd", "cl", "ce", "cu", "ct"].forEach(id => $(id).addEventListener("input", calc));
$("af").addEventListener("click", () => { const s = state(); $("re").value = Math.min(298, Math.max(80, Math.round((s.xi + SCR_IDX) * 2) / 2)); draw(); });
const view = (p, t) => { cam.position.set(...p); ctl.target.set(...t); ctl.update(); };
$("rd").addEventListener("click", () => view([150, 420, 40], [150, 0, 0]));
$("sv").addEventListener("click", () => { const s = state(), hx = s.xc - SRC_D; view([hx + 140, M.zax + 45, 150], [hx, M.zax, 0]); });
$("rv").addEventListener("click", () => view([60, 260, 800], [130, 30, 0]));
function resize() { const v = $("view"); renderer.setSize(v.clientWidth, v.clientHeight, false); cam.aspect = v.clientWidth / v.clientHeight; cam.updateProjectionMatrix(); }
addEventListener("resize", resize); view([60, 260, 800], [130, 30, 0]); resize(); draw();
function onLang() { draw(); }
setLang(LANG);
let frames = 0;      // en mode test (Chrome headless : window.__errs defini) on s'arrete apres 40 images
(function loop() { ctl.update(); renderer.render(scene, cam); if (!(window.__errs && ++frames > 40)) requestAnimationFrame(loop); })();
</script></body></html>
