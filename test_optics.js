// node test_optics.js : verifie le modele (coherence avec calcul_oculaire.py) puis explore les pistes pour agrandir le champ
const O = require("./optics.js");
const fmt = (n, d = 1) => n.toFixed(d);
function row(label, p) {
  const r = O.analyze(p);
  console.log(label.padEnd(46), "F", fmt(r.fo.EFL).padStart(5), " foyer-av", fmt(r.fo.ffd).padStart(5),
    " ER", fmt(r.ER).padStart(5), " champ 100%", fmt(r.afov100).padStart(5) + "°", " 50%", fmt(r.afov50).padStart(5) + "°",
    " limite:", r.limit);
  return r;
}
// 1. controle : deux paires minces au contact (doit retrouver F = F1*F2/(F1+F2-d))
const c = O.analyze({ t40: 0.01, t30: 0.01, airIn: 0, gap: 10 });
const F1 = 80, F2 = 55, d = 10;
console.log("controle  F modele", fmt(c.fo.EFL, 2), " F theorie", fmt(F1 * F2 / (F1 + F2 - d), 2));

console.log("\n--- base : focales typiques de jumelles (A MESURER) ---");
row("base  f40=160 f30=110", {});
row("base  f40=100 f30=75 (jumelles courtes)", { f40: 100, f30: 75 });

console.log("\n--- piste 1 : ouverture de la paire oeil ---");
for (const a of [29, 31, 33, 35, 37]) row("ouverture oeil Ø" + a, { a30: a });

console.log("\n--- piste 2 : degagement d'oeil impose (compromis) ---");
for (const er of [0, 25, 20, 15, 10]) row("degagement " + (er || "libre"), { erOverride: er });

console.log("\n--- piste 3 : 4 achromats Ø40 (4 x Ø40 : F et champ vs focales de jumelles) ---");
row("quad Ø40, f40=160", { quad40: true });
row("quad Ø40, f40=100", { quad40: true, f40: 100 });

console.log("\n--- piste 4 : lentille de champ Ø37 a l'entree ---");
for (const f of [400, 250, 150, 100]) row("lentille de champ f=" + f, { fl: { on: true, f, gapToG1: 2 } });
console.log("\n--- piste 4b : lentille de champ + oeil Ø33 ---");
for (const f of [400, 250, 150]) row("champ f=" + f + " + oeil Ø33", { a30: 33, fl: { on: true, f, gapToG1: 2 } });

console.log("\n--- piste 5 : pupille de sortie (taille du faisceau) ---");
for (const p of [1, 2, 4, 6]) row("pupille " + p + " mm", { pupil: p });

console.log("\n--- piste 6 : espace entre groupes ---");
for (const g of [0.5, 1.5, 5, 10, 20]) row("gap " + g + " mm", { gap: g });
