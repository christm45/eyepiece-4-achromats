/* Modele optique paraxial de l'oculaire a achromats (lentilles minces, ouvertures finies).
   Source unique : utilisee par la page HTML et par test_optics.js (Node).
   Axe z : 0 = cote telescope, croissant vers l'oeil. Unites : mm.
   Les groupes sont des paires d'achromats qui se font face ; chaque achromat = une lentille mince
   placee au milieu de son epaisseur. Valable au premier ordre : ne donne PAS la nettete
   (astigmatisme, courbure de champ, coma) mais donne la geometrie : vignettage, champ, degagement. */
(function (root) {
  const DEF = {
    f40: 160, f30: 110,        // focales d'un achromat (mm) -- A MESURER
    t40: 8, t30: 6,            // epaisseurs au centre (mm) -- A MESURER
    a40: 37, a30: 29,          // ouvertures utiles (mm)
    airIn: 0.5,                // air dans une paire (entretoise fine)
    gap: 1.5,                  // air entre les deux groupes (mm)
    pupil: 4,                  // pupille de sortie du telescope (mm)
    fsMax: 46,                 // champ max du fourreau 2" (mm)
    erOverride: 0,             // 0 = pupille de l'oeil au foyer image de l'oculaire
    // lentille de champ optionnelle (a l'entree, avant la paire 40)
    fl: { on: false, f: 200, ap: 37, gapToG1: 2, t: 5 },
    // variante : 2e paire en Ø40 au lieu de Ø30
    quad40: false
  };

  function build(p) {
    p = Object.assign({}, DEF, p || {});
    p.fl = Object.assign({}, DEF.fl, (p && p.fl) || {});
    const L = [];                       // lentilles minces, ordre telescope -> oeil
    let z = 0;
    const add = (name, f, ap, t, grp) => { L.push({ name, f, R: ap / 2, z: z + t / 2, t, z0: z, grp }); z += t; };
    if (p.groups) {                     // mode libre : 2 ou 3 groupes de 2 achromats, diametre et focales au choix
      const AP = { 30: 29, 40: 37, 50: 46 }, TT = { 30: 6, 40: 8, 50: 10 };
      p.groups.forEach((g, i) => {
        add("Ø" + g.d + " G" + (i + 1) + "a", g.f[0], AP[g.d], TT[g.d], "G" + (i + 1)); z += p.airIn;
        add("Ø" + g.d + " G" + (i + 1) + "b", g.f[1], AP[g.d], TT[g.d], "G" + (i + 1));
        if (i < p.groups.length - 1) z += p.gap;
      });
      return { p, L, zEnd: z };
    }
    if (p.fl.on) { add("lentille de champ", p.fl.f, p.fl.ap, p.fl.t, "F"); z += p.fl.gapToG1; }
    add("Ø40 #1", p.f40, p.a40, p.t40, "G1"); z += p.airIn;
    add("Ø40 #2", p.f40, p.a40, p.t40, "G1"); z += p.gap;
    if (p.mid && p.mid.on) { add("achromat Ø50 central", p.mid.f, p.mid.ap, p.mid.t, "M"); z += p.gap; }
    const f2 = p.quad40 ? p.f40 : p.f30, a2 = p.quad40 ? p.a40 : p.a30, t2 = p.quad40 ? p.t40 : p.t30;
    add(p.quad40 ? "Ø40 #3" : "Ø30 #1", f2, a2, t2, "G2"); z += p.airIn;
    add(p.quad40 ? "Ø40 #4" : "Ø30 #2", f2, a2, t2, "G2");
    return { p, L, zEnd: z };
  }

  // rayon qui part de l'oeil vers le telescope : (y,u) apres la derniere lentille, u = pente "avant"
  function backTrace(sys, yp, s_e, zp) {
    const pts = [{ z: zp, y: yp }];
    let y = yp + s_e * (sys.L[sys.L.length - 1].z - zp);   // hauteur a la derniere lentille
    let s = s_e;
    const hits = [];
    for (let i = sys.L.length - 1; i >= 0; i--) {
      const l = sys.L[i];
      hits.unshift({ i, y });
      pts.unshift({ z: l.z, y });
      s = s + y / l.f;                                      // pente avant la lentille
      const zprev = i > 0 ? sys.L[i - 1].z : null;
      if (zprev !== null) y = y - s * (l.z - zprev);
      else return { pts, hits, s_first: s, y_first: y };
    }
  }

  // foyer avant (position du plan de champ) et focale, degagement d'oeil
  function firstOrder(sys) {
    const l0 = sys.L[0];
    // rayon parallele a la sortie, hauteur 1 : revient du foyer avant
    const r = backTrace(sys, 1, 0, sys.L[sys.L.length - 1].z + 0); // yp=1 a la derniere lentille, pente 0
    const EFL = 1 / Math.abs(r.s_first);
    const zFocus = l0.z - r.y_first / r.s_first;           // plan de champ
    // degagement : rayon parallele entrant, hauteur 1, trace avant
    let y = 1, s = 0;
    for (let i = 0; i < sys.L.length; i++) {
      const l = sys.L[i];
      if (i > 0) y += s * (l.z - sys.L[i - 1].z);
      s = s - y / l.f;
    }
    const last = sys.L[sys.L.length - 1];
    const BFD = -y / s;                                    // distance depuis la derniere lentille
    return { EFL, zFocus, BFD, ffd: l0.z - zFocus };
  }

  // fraction du faisceau (pupille +-p/2) qui passe toutes les ouvertures pour une pente chef s_e
  function transmit(sys, fo, s_e, zp) {
    const half = sys.p.pupil / 2;
    let lo = -half, hi = half;
    // contraintes lineaires en yp : y_i(yp) = yc + k*yp
    const c = backTrace(sys, 0, s_e, zp), a = backTrace(sys, 1, s_e, zp);
    const cons = [];
    sys.L.forEach((l, i) => cons.push({ yc: c.hits[i].y, k: a.hits[i].y - c.hits[i].y, R: l.R }));
    // plan de champ : hauteur h
    const zf = fo.zFocus, l0 = sys.L[0];
    const yF = (b) => b.y_first - b.s_first * (l0.z - zf);
    const hc = yF(c), hk = yF(a) - hc;
    cons.push({ yc: hc, k: hk, R: sys.p.fsMax / 2 });
    for (const q of cons) {
      if (Math.abs(q.k) < 1e-9) { if (Math.abs(q.yc) > q.R) { return { frac: 0, h: hc, cons }; } continue; }
      const t1 = (-q.R - q.yc) / q.k, t2 = (q.R - q.yc) / q.k;
      lo = Math.max(lo, Math.min(t1, t2)); hi = Math.min(hi, Math.max(t1, t2));
    }
    return { frac: Math.max(0, hi - lo) / sys.p.pupil, h: hc, cons };
  }

  function analyze(params) {
    const sys = build(params), fo = firstOrder(sys);
    const last = sys.L[sys.L.length - 1];
    const ER = sys.p.erOverride > 0 ? sys.p.erOverride : fo.BFD;
    const zp = last.z + ER;
    const out = { sys, fo, ER, zp, curve: [] };
    let a100 = 0, a50 = 0, lim = null;
    for (let deg = 0; deg <= 45; deg += 0.25) {
      const s_e = Math.tan(deg * Math.PI / 180);
      const r = transmit(sys, fo, s_e, zp);
      out.curve.push({ deg, frac: r.frac, h: r.h });
      if (r.frac >= 0.999) a100 = deg;
      if (r.frac >= 0.5) a50 = deg;
    }
    out.afov100 = 2 * a100; out.afov50 = 2 * a50;
    // quel element limite a 50 % ?
    const sL = Math.tan((a50 + 0.5) * Math.PI / 180), r2 = transmit(sys, fo, sL, zp);
    if (r2.cons) {
      let worst = -1, wv = 1e9;
      r2.cons.forEach((q, i) => {
        const m = q.R - Math.abs(q.yc);           // marge chef
        if (m < wv) { wv = m; worst = i; }
      });
      lim = worst < sys.L.length ? sys.L[worst].name : "diaphragme de champ (fourreau 2\")";
    }
    out.limit = lim;
    out.maxFieldStop = 2 * Math.abs(transmit(sys, fo, Math.tan(a50 * Math.PI / 180), zp).h);
    out.afovStop = 2 * Math.atan(sys.p.fsMax / 2 / fo.EFL) * 180 / Math.PI;   // plafond du fourreau
    return out;
  }

  const api = { DEF, build, firstOrder, backTrace, transmit, analyze };
  if (typeof module !== "undefined" && module.exports) module.exports = api; else root.Optics = api;
})(typeof window !== "undefined" ? window : globalThis);
