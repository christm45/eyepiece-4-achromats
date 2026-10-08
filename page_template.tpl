<!doctype html>
<html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Oculaire 4 achromats - assemblage 3D et champ</title>
<style>
:root{--bg:#10151c;--pan:#171e28;--ln:#2a3544;--tx:#dbe4ef;--mu:#8fa0b5;--ac:#4aa3ff;--ok:#5ed39a;--wa:#ffb454;--bad:#ff7a7a}
*{box-sizing:border-box}html,body{margin:0;height:100%;background:var(--bg);color:var(--tx);font:14px/1.45 system-ui,Segoe UI,sans-serif}
#app{display:grid;grid-template-columns:minmax(0,1fr) 440px;height:100vh}
#view{position:relative;min-width:0}#cv{width:100%;height:100%;display:block}
#hud{position:absolute;left:12px;top:10px;display:flex;flex-wrap:wrap;gap:6px;max-width:calc(100% - 130px)}
.chip{background:#0c1117cc;border:1px solid var(--ln);border-radius:8px;padding:5px 9px;font-size:12px;color:var(--mu);backdrop-filter:blur(4px)}
.chip b{color:var(--tx);font-weight:600}
#parts{position:absolute;left:12px;bottom:12px;background:#0c1117d9;border:1px solid var(--ln);border-radius:10px;padding:8px 10px;font-size:12px;max-width:290px}
#parts label{display:flex;align-items:center;gap:7px;padding:1px 0;cursor:pointer}
#parts i{width:11px;height:11px;border-radius:3px;display:inline-block}
#side{background:var(--pan);border-left:1px solid var(--ln);overflow:auto;padding:14px 16px 40px}
h1{font-size:16px;margin:0 0 2px}h2{font-size:13px;margin:20px 0 8px;color:var(--ac);text-transform:uppercase;letter-spacing:.06em}
p{margin:6px 0}.mu{color:var(--mu)}.note{font-size:12px;color:var(--mu)}
.row{display:grid;grid-template-columns:128px 1fr 54px;gap:8px;align-items:center;margin:3px 0}
.row span{font-size:12px;color:var(--mu)}.row output{font-size:12px;text-align:right;color:var(--tx);font-variant-numeric:tabular-nums}
input[type=range]{width:100%;accent-color:var(--ac)}
.chk{display:flex;gap:8px;align-items:center;margin:5px 0;font-size:13px}
.kpi{display:grid;grid-template-columns:repeat(4,1fr);gap:6px;margin:10px 0}
.kpi div{background:#0f151d;border:1px solid var(--ln);border-radius:8px;padding:6px 8px}
.kpi small{display:block;color:var(--mu);font-size:11px}.kpi b{font-size:17px;font-variant-numeric:tabular-nums}
canvas#cur{width:100%;height:150px;background:#0f151d;border:1px solid var(--ln);border-radius:8px}
table{width:100%;border-collapse:collapse;font-size:12px;font-variant-numeric:tabular-nums}
th,td{padding:4px 5px;border-bottom:1px solid var(--ln);text-align:right}th:first-child,td:first-child{text-align:left}
th{color:var(--mu);font-weight:500}tr.b td{color:var(--tx)}td.g{color:var(--ok)}td.r{color:var(--bad)}
.warn{border-left:3px solid var(--wa);background:#241d10;padding:7px 10px;border-radius:0 8px 8px 0;font-size:12.5px;margin:10px 0}
.card{background:#0f151d;border:1px solid var(--ln);border-radius:10px;padding:9px 12px;margin:8px 0}
.card b{color:var(--ac)}
@media(max-width:900px){#app{grid-template-columns:1fr;grid-template-rows:55vh auto;height:auto}#side{border-left:0}}
#lang{position:absolute;right:12px;top:10px;display:flex;z-index:2}#lang button{background:#0c1117cc;color:var(--mu);border:1px solid var(--ln);padding:5px 10px;font-size:12px;cursor:pointer}#lang button:first-child{border-radius:8px 0 0 8px}#lang button:last-child{border-radius:0 8px 8px 0;border-left:0}#lang button.on{color:var(--tx);border-color:var(--ac);background:#16324f}
.vb{background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px 9px;cursor:pointer;font-size:12px}.vb:hover{border-color:var(--ac)}</style></head><body>
<div id="app">
 <div id="view"><canvas id="cv"></canvas>
  <div id="hud"></div>
  <div id="lang"><button data-l="fr">FR</button><button data-l="en">EN</button></div>
  <div id="parts"></div></div>
 <div id="side">
  <h1>Oculaire 4 achromats : assemblage et champ</h1>
  <p class="mu">Paire Ø40 côté focuser 2" + paire Ø30 côté œil. Cotes lues sur vos captures Onshape ; longueurs et épaisseurs de lentilles estimées.</p>

  <h2>Vue 3D</h2>
  <label class="chk"><input id="real" type="checkbox" checked> Rendu réaliste (reflets, verre, ombres)</label>
  <div class="row"><span>Filament</span><select id="fil" style="grid-column:2/4;background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px"><option value="code">Studio couleur (par pièce)</option><option value="noir">PLA noir mat</option><option value="gris">PETG gris anthracite</option><option value="blanc">PLA blanc</option></select></div>
  <div class="row"><span>Vues</span><div style="grid-column:2/4;display:flex;gap:6px;flex-wrap:wrap"><button class="vb" data-v="face">Face</button><button class="vb" data-v="oeil">Côté œil</button><button class="vb" data-v="tele">Côté télescope</button><button class="vb" data-v="profil">Profil</button></div></div>
  <div class="row"><span>Éclaté</span><input id="ex" type="range" min="0" max="18" step="0.5" value="0"><output id="exo">0</output></div>
  <div class="row"><span>Opacité du verre</span><input id="op" type="range" min="0.1" max="1" step="0.05" value="0.35"><output id="opo">0.35</output></div>
  <label class="chk"><input id="cut" type="checkbox"> Coupe longitudinale (suit la caméra)</label>
  <label class="chk"><input id="rays" type="checkbox" checked> Afficher les rayons (désactivés en éclaté)</label>
  <div class="row"><span>Angle du champ (demi)</span><input id="ang" type="range" min="0" max="35" step="0.5" value="18"><output id="ango">18</output></div>

  <h2>Architecture de l'oculaire</h2>
  <label class="chk"><input id="cust" type="checkbox"> Mode multi-groupes libre (calcul optique seulement ; le modèle 3D reste Ø40 + Ø30)</label>
  <div id="custbox" style="display:none">
   <div class="row"><span>Architecture</span><select id="arch" style="grid-column:2/4;background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px">
    <option value="40,30">2 groupes : Ø40 + Ø30 (modèle 3D)</option><option value="50,30">2 groupes : Ø50 + Ø30</option><option value="50,40">2 groupes : Ø50 + Ø40</option>
    <option value="50,50">2 groupes : Ø50 + Ø50</option><option value="50,50,50">3 groupes : Ø50 + Ø50 + Ø50</option>
    <option value="50,40,30">3 groupes : Ø50 + Ø40 + Ø30</option><option value="40,40,30">3 groupes : Ø40 + Ø40 + Ø30</option></select></div>
   <div class="warn" style="margin:6px 0"><b>Focales des jumelles (estimées)</b> : l'objectif d'une jumelle ouvre à f/3,5–f/5, donc environ <b>Ø30 : 105–150 mm</b> (8x30), <b>Ø40 : 140–200 mm</b> (8x40), <b>Ø50 : 175–250 mm</b> (7x50, 8x50, 10x50). Mesurez-les avec le banc pour le vrai chiffre.</div>
   <p class="note">Un groupe = 2 achromats accolés (air 0,5 mm). Indiquez la focale de chaque lentille (mm) ; l'écart entre groupes est le curseur « Air entre groupes ».</p>
   <div id="grows"></div>
   <p class="note" style="margin-top:8px"><b>Mes lentilles en stock</b> (focales séparées par des virgules, utilisées par la recherche) :</p>
   <div id="stock"></div>
  </div>

  <h2>Choix des lentilles</h2>
  <div class="row"><span>Combinaison type</span><select id="pre" style="grid-column:2/4;background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:4px">
   <option value="">- choisir -</option>
   <option value="160,110,1.5,0">Actuel : Ø40 f160 + Ø30 f110, écart 1,5</option>
   <option value="140,105,12,0">2 groupes grand champ : Ø40 f140 + Ø30 f105, écart 12</option>
   <option value="160,120,6,0">2 groupes : Ø40 f160 + Ø30 f120, écart 6</option>
   <option value="200,200,1.5,0">4 × Ø40 f200 (écart 1,5)</option></select></div>
  <p class="note" style="margin-top:10px"><b>Recherche automatique</b> : balaie des focales de jumelles (Ø40 : 120–220, Ø30 : 90–170 mm) et l'écart entre groupes avec vos ouvertures, et classe les combinaisons.</p>
  <div class="row"><span>Champ 50 % max (°)</span><input id="s_cap" type="range" min="40" max="90" step="1" value="60"><output id="o_cap">60</output></div>
  <div class="row"><span>Dégagement min (mm)</span><input id="s_ermin" type="range" min="8" max="30" step="1" value="15"><output id="o_ermin">15</output></div>
  <button class="vb" id="srch" style="margin:4px 0 8px">Chercher les meilleures combinaisons</button>
  <table id="best"></table>
  <p class="note">Clic sur une ligne pour l'appliquer aux curseurs. Le modèle 3D garde son écart de 1,5 mm : seuls F, dégagement et champ sont recalculés pour un autre écart.</p>

  <h2>Paramètres optiques</h2>
  <div class="warn">Les focales par défaut (160 / 110 mm) sont typiques de jumelles, <b>pas mesurées</b>. Entrez les vôtres : tous les chiffres se recalculent.</div>
  <div id="sl"></div>
  <label class="chk"><input id="fl" type="checkbox"> Lentille de champ à l'entrée (Ø37)</label>
  <div id="flrow"></div>
  <label class="chk"><input id="q40" type="checkbox"> Variante 4 × Ø40 (la paire œil aussi en Ø40)</label>

  <div class="kpi" id="kpi"></div>
  <canvas id="cur" width="420" height="150"></canvas>
  <p class="note" id="lim"></p>

  <h2>Pistes pour agrandir le champ (calculées avec vos valeurs)</h2>
  <table id="tab"></table>
  <p class="note">« Champ 100 % » = angle apparent où l'éclairement reste complet ; « 50 % » = bord à demi assombri. Pupille de sortie du télescope prise à 4 mm.</p>

  <h2>Ce que dit la physique</h2>
  <div class="card"><b>1. Trois plafonds géométriques.</b> Le champ apparent est limité par (a) le diaphragme de champ, au plus Ø46 dans un fourreau 2", soit 2·atan(46 ÷ 2F) ; (b) l'ouverture de la lentille côté œil, vue depuis le point de l'œil ; (c) l'ouverture de la paire côté télescope. C'est toujours la plus petite qui commande, et elle est affichée sous la courbe.</div>
  <div class="card"><b>2. Dégagement d'œil contre champ.</b> Le faisceau d'un point du bord traverse la lentille œil à une hauteur ≈ dégagement × tan(angle). Reculer l'œil de 5 mm coûte plusieurs degrés. Pour gagner du champ à ouverture égale, il faut accepter moins de dégagement : c'est le levier le plus puissant, et il ne coûte aucune pièce.</div>
  <div class="card"><b>3. Ouvrir la lentille œil.</b> Passer de Ø29 à Ø31–33 utile (en agrandissant l'épaulement et la bague) rapporte quelques degrés tant que la paire Ø40 ne limite pas. Au-delà, c'est elle qui plafonne.</div>
  <div class="card"><b>4. Lentille de champ.</b> Une lentille positive 2 à 5 mm avant le foyer ne change presque pas F mais ramène les rayons du bord vers l'axe : le faisceau passe dans les lentilles suivantes sans vignettage. Elle devient elle-même le diaphragme de champ (Ø37) : le gain est réel mais plafonné. Placez-la <b>jamais dans le plan focal</b> (poussières et cément visibles).</div>
  <div class="card"><b>5. Lentille entre les groupes.</b> Cet espace est presque collimaté : une lentille y agit surtout comme un élargisseur de pupille (type Erfle) et ne repousse pas le diaphragme de champ. Utile seulement si le vignettage vient de la paire œil.</div>
  <div class="card"><b>6. Focale d'oculaire.</b> À diaphragme égal, raccourcir F agrandit l'angle (2·atan(fs ÷ 2F)) mais réduit dégagement et pupille de sortie. Les 38 mm / 60° à 4 Ø40 cités plus haut supposent des objectifs de jumelles plus courts (≈ f 100–125) que ceux des valeurs par défaut.</div>
  <div class="card"><b>7. Distorsion.</b> Un oculaire de type Plössl a une distorsion en coussinet (grossissement angulaire croissant avec le champ) qui fait paraître le champ réel plus grand que le calcul au premier ordre : attendez-vous à quelques degrés de plus que les nombres ci-dessus.</div>
  <div class="warn"><b>Limite du modèle.</b> Premier ordre, lentilles minces, ouvertures finies : il donne la géométrie (vignettage, dégagement, F) mais <b>pas la netteté au bord</b> (astigmatisme, courbure de champ, coma). Un tracé de rayons réel demande les rayons de courbure de vos achromats ; la netteté dépend aussi du rapport f/D du télescope.</div>
 </div>
</div>
<script>__THREE__</script>
<script>__ORBIT__</script>
<script>__ROOMENV__</script>
<script>__OPTICS__</script>
<script>
const TITLE_EN = "4-achromat eyepiece - 3D assembly and field";
const DICT = [
["Oculaire 4 achromats : assemblage et champ","4-achromat eyepiece: assembly and field"],
['Paire Ø40 côté focuser 2" + paire Ø30 côté œil. Cotes lues sur vos captures Onshape ; longueurs et épaisseurs de lentilles estimées.','Ø40 pair on the 2" focuser side + Ø30 pair on the eye side. Dimensions read from Onshape screenshots; lens lengths and thicknesses are estimated.'],
["Vue 3D","3D view"],
["Rendu réaliste (reflets, verre, ombres)","Realistic rendering (reflections, glass, shadows)"],
["Studio couleur (par pièce)","Studio colour (per part)"],["PLA noir mat","Matte black PLA"],["PETG gris anthracite","Anthracite grey PETG"],["PLA blanc","White PLA"],
["Vues","Views"],["Face","Front"],["Côté œil","Eye side"],["Côté télescope","Telescope side"],["Profil","Side"],
["Éclaté","Exploded"],["Opacité du verre","Glass opacity"],
["Coupe longitudinale (suit la caméra)","Longitudinal section (follows the camera)"],
["Afficher les rayons (désactivés en éclaté)","Show rays (disabled when exploded)"],
["Angle du champ (demi)","Field angle (half)"],
["Architecture de l'oculaire","Eyepiece architecture"],
["Mode multi-groupes libre (calcul optique seulement ; le modèle 3D reste Ø40 + Ø30)","Free multi-group mode (optical calculation only; the 3D model stays Ø40 + Ø30)"],
["2 groupes : Ø40 + Ø30 (modèle 3D)","2 groups: Ø40 + Ø30 (3D model)"],["2 groupes : Ø50 + Ø30","2 groups: Ø50 + Ø30"],["2 groupes : Ø50 + Ø40","2 groups: Ø50 + Ø40"],
["2 groupes : Ø50 + Ø50","2 groups: Ø50 + Ø50"],["3 groupes : Ø50 + Ø50 + Ø50","3 groups: Ø50 + Ø50 + Ø50"],
["3 groupes : Ø50 + Ø40 + Ø30","3 groups: Ø50 + Ø40 + Ø30"],["3 groupes : Ø40 + Ø40 + Ø30","3 groups: Ø40 + Ø40 + Ø30"],
["<b>Focales des jumelles (estimées)</b> : l'objectif d'une jumelle ouvre à f/3,5–f/5, donc environ <b>Ø30 : 105–150 mm</b> (8x30), <b>Ø40 : 140–200 mm</b> (8x40), <b>Ø50 : 175–250 mm</b> (7x50, 8x50, 10x50). Mesurez-les avec le banc pour le vrai chiffre.",
 "<b>Binocular focal lengths (estimated)</b>: a binocular objective runs at f/3.5–f/5, so roughly <b>Ø30: 105–150 mm</b> (8x30), <b>Ø40: 140–200 mm</b> (8x40), <b>Ø50: 175–250 mm</b> (7x50, 8x50, 10x50). Measure them with the test bench for the real figure."],
["Un groupe = 2 achromats accolés (air 0,5 mm). Indiquez la focale de chaque lentille (mm) ; l'écart entre groupes est le curseur « Air entre groupes ».","One group = 2 achromats back to back (0.5 mm air gap). Enter each lens's focal length (mm); the spacing between groups is the “Air between groups” slider."],
["<b>Mes lentilles en stock</b> (focales séparées par des virgules, utilisées par la recherche) :","<b>My lenses in stock</b> (focal lengths separated by commas, used by the search):"],
["Choix des lentilles","Lens selection"],["Combinaison type","Typical combination"],["- choisir -","- choose -"],
["Actuel : Ø40 f160 + Ø30 f110, écart 1,5","Current: Ø40 f160 + Ø30 f110, gap 1.5"],
["2 groupes grand champ : Ø40 f140 + Ø30 f105, écart 12","2 groups, wide field: Ø40 f140 + Ø30 f105, gap 12"],
["2 groupes : Ø40 f160 + Ø30 f120, écart 6","2 groups: Ø40 f160 + Ø30 f120, gap 6"],
["4 × Ø40 f200 (écart 1,5)","4 × Ø40 f200 (gap 1.5)"],
["<b>Recherche automatique</b> : balaie des focales de jumelles (Ø40 : 120–220, Ø30 : 90–170 mm) et l'écart entre groupes avec vos ouvertures, et classe les combinaisons.","<b>Automatic search</b>: sweeps binocular focal lengths (Ø40: 120–220, Ø30: 90–170 mm) and the gap between groups with your apertures, and ranks the combinations."],
["Champ 50 % max (°)","Max 50 % field (°)"],["Dégagement min (mm)","Min eye relief (mm)"],
["Chercher les meilleures combinaisons","Find the best combinations"],
["Clic sur une ligne pour l'appliquer aux curseurs. Le modèle 3D garde son écart de 1,5 mm : seuls F, dégagement et champ sont recalculés pour un autre écart.","Click a row to apply it to the sliders. The 3D model keeps its 1.5 mm gap: only F, eye relief and field are recalculated for a different gap."],
["Paramètres optiques","Optical parameters"],
["Les focales par défaut (160 / 110 mm) sont typiques de jumelles, <b>pas mesurées</b>. Entrez les vôtres : tous les chiffres se recalculent.","The default focal lengths (160 / 110 mm) are typical of binoculars, <b>not measured</b>. Enter your own: all figures are recalculated."],
["Focale Ø40 (mm)","Ø40 focal length (mm)"],["Focale Ø30 (mm)","Ø30 focal length (mm)"],["Ouverture utile œil (mm)","Eye-side clear aperture (mm)"],
["Ouverture utile Ø40 (mm)","Ø40 clear aperture (mm)"],["Air entre groupes (mm)","Air between groups (mm)"],["Pupille de sortie (mm)","Exit pupil (mm)"],
["Dégagement imposé (0 = libre)","Forced eye relief (0 = free)"],["Focale lentille de champ","Field lens focal length"],
["Lentille de champ à l'entrée (Ø37)","Field lens at the entrance (Ø37)"],["Variante 4 × Ø40 (la paire œil aussi en Ø40)","4 × Ø40 variant (eye-side pair also Ø40)"],
["Pistes pour agrandir le champ (calculées avec vos valeurs)","Ways to widen the field (calculated with your values)"],
["« Champ 100 % » = angle apparent où l'éclairement reste complet ; « 50 % » = bord à demi assombri. Pupille de sortie du télescope prise à 4 mm.","“100 % field” = apparent angle where illumination stays complete; “50 %” = edge half darkened. Telescope exit pupil taken as 4 mm."],
["Ce que dit la physique","What the physics says"],
["<b>1. Trois plafonds géométriques.</b> Le champ apparent est limité par (a) le diaphragme de champ, au plus Ø46 dans un fourreau 2\", soit 2·atan(46 ÷ 2F) ; (b) l'ouverture de la lentille côté œil, vue depuis le point de l'œil ; (c) l'ouverture de la paire côté télescope. C'est toujours la plus petite qui commande, et elle est affichée sous la courbe.",
 "<b>1. Three geometric ceilings.</b> The apparent field is limited by (a) the field stop, at most Ø46 in a 2\" barrel, i.e. 2·atan(46 ÷ 2F); (b) the aperture of the eye-side lens, seen from the eye point; (c) the aperture of the telescope-side pair. The smallest one always rules, and it is shown under the curve."],
["<b>2. Dégagement d'œil contre champ.</b> Le faisceau d'un point du bord traverse la lentille œil à une hauteur ≈ dégagement × tan(angle). Reculer l'œil de 5 mm coûte plusieurs degrés. Pour gagner du champ à ouverture égale, il faut accepter moins de dégagement : c'est le levier le plus puissant, et il ne coûte aucune pièce.",
 "<b>2. Eye relief versus field.</b> The beam from an edge point crosses the eye lens at a height ≈ eye relief × tan(angle). Moving the eye back 5 mm costs several degrees. To gain field at equal aperture you must accept less eye relief: it is the most powerful lever, and it costs no parts."],
["<b>3. Ouvrir la lentille œil.</b> Passer de Ø29 à Ø31–33 utile (en agrandissant l'épaulement et la bague) rapporte quelques degrés tant que la paire Ø40 ne limite pas. Au-delà, c'est elle qui plafonne.",
 "<b>3. Opening up the eye lens.</b> Going from Ø29 to Ø31–33 clear aperture (by enlarging the shoulder and the ring) gains a few degrees as long as the Ø40 pair is not the limit. Beyond that, it becomes the ceiling."],
["<b>4. Lentille de champ.</b> Une lentille positive 2 à 5 mm avant le foyer ne change presque pas F mais ramène les rayons du bord vers l'axe : le faisceau passe dans les lentilles suivantes sans vignettage. Elle devient elle-même le diaphragme de champ (Ø37) : le gain est réel mais plafonné. Placez-la <b>jamais dans le plan focal</b> (poussières et cément visibles).",
 "<b>4. Field lens.</b> A positive lens 2 to 5 mm before the focus hardly changes F but bends the edge rays back toward the axis: the beam goes through the following lenses without vignetting. It becomes the field stop itself (Ø37): the gain is real but capped. Place it <b>never in the focal plane</b> (dust and cement would be visible)."],
["<b>5. Lentille entre les groupes.</b> Cet espace est presque collimaté : une lentille y agit surtout comme un élargisseur de pupille (type Erfle) et ne repousse pas le diaphragme de champ. Utile seulement si le vignettage vient de la paire œil.",
 "<b>5. Lens between the groups.</b> This space is almost collimated: a lens there mostly acts as a pupil expander (Erfle type) and does not push back the field stop. Useful only if the vignetting comes from the eye-side pair."],
["<b>6. Focale d'oculaire.</b> À diaphragme égal, raccourcir F agrandit l'angle (2·atan(fs ÷ 2F)) mais réduit dégagement et pupille de sortie. Les 38 mm / 60° à 4 Ø40 cités plus haut supposent des objectifs de jumelles plus courts (≈ f 100–125) que ceux des valeurs par défaut.",
 "<b>6. Eyepiece focal length.</b> At equal field stop, shortening F widens the angle (2·atan(fs ÷ 2F)) but reduces eye relief and exit pupil. The 38 mm / 60° with 4 Ø40 quoted above assume shorter binocular objectives (≈ f 100–125) than the default values."],
["<b>7. Distorsion.</b> Un oculaire de type Plössl a une distorsion en coussinet (grossissement angulaire croissant avec le champ) qui fait paraître le champ réel plus grand que le calcul au premier ordre : attendez-vous à quelques degrés de plus que les nombres ci-dessus.",
 "<b>7. Distortion.</b> A Plössl-type eyepiece has pincushion distortion (angular magnification growing with field) which makes the real field look larger than the first-order calculation: expect a few degrees more than the numbers above."],
["<b>Limite du modèle.</b> Premier ordre, lentilles minces, ouvertures finies : il donne la géométrie (vignettage, dégagement, F) mais <b>pas la netteté au bord</b> (astigmatisme, courbure de champ, coma). Un tracé de rayons réel demande les rayons de courbure de vos achromats ; la netteté dépend aussi du rapport f/D du télescope.",
 "<b>Model limit.</b> First order, thin lenses, finite apertures: it gives the geometry (vignetting, eye relief, F) but <b>not edge sharpness</b> (astigmatism, field curvature, coma). A real ray trace needs the radii of curvature of your achromats; sharpness also depends on the telescope's f/D ratio."],
["1 base basse Ø50,8 (poche 40 x 27)","1 low base Ø50.8 (40 x 27 pocket)"],["2 cale sous la paire Ø40","2 shim under the Ø40 pair"],["3 coiffe oeil (poche 30)","3 eye cap (30 pocket)"],
["4 bague de serrage cote oeil","4 clamping ring, eye side"],["5 bague d'espacement paire Ø40","5 spacer ring, Ø40 pair"],["6 bague d'espacement paire Ø30","6 spacer ring, Ø30 pair"],
["Ø40 #1 achromat (cote telescope)","Ø40 #1 achromat (telescope side)"],["Ø40 #2 achromat","Ø40 #2 achromat"],["Ø30 #1 achromat","Ø30 #1 achromat"],["Ø30 #2 achromat (cote oeil)","Ø30 #2 achromat (eye side)"]
];
</script>
<script>__I18N__</script>
<script>
const DATA = __DATA__;
const $ = id => document.getElementById(id);
const dec = b64 => { const s = atob(b64), u = new Uint8Array(s.length); for (let i = 0; i < s.length; i++) u[i] = s.charCodeAt(i); return new Float32Array(u.buffer); };

// ---------- scene ----------
const cv = $("cv"), renderer = new THREE.WebGLRenderer({ canvas: cv, antialias: true });
renderer.setPixelRatio(Math.min(devicePixelRatio, 2)); renderer.shadowMap.enabled = true; renderer.shadowMap.type = THREE.PCFSoftShadowMap; renderer.outputEncoding = THREE.sRGBEncoding; renderer.localClippingEnabled = true; renderer.setClearColor(0x10151c);
const scene = new THREE.Scene(), cam = new THREE.PerspectiveCamera(35, 1, 1, 2000);
cam.position.set(190, 120, 200);
const ctl = new THREE.OrbitControls(cam, cv); ctl.target.set(0, 55, 0); ctl.enableDamping = true; ctl.update();
scene.add(new THREE.HemisphereLight(0xffffff, 0x20262e, 0.95));
const dl = new THREE.DirectionalLight(0xffffff, 0.6); dl.position.set(120, 200, 140); scene.add(dl);
const dl2 = new THREE.DirectionalLight(0x88aaff, 0.35); dl2.position.set(-150, 40, -120); scene.add(dl2);
const grid = new THREE.GridHelper(300, 30, 0x2a3544, 0x1b2330); scene.add(grid);
const axis = new THREE.Line(new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(0, -30, 0), new THREE.Vector3(0, 150, 0)]),
  new THREE.LineDashedMaterial({ color: 0x4aa3ff, dashSize: 4, gapSize: 3 })); axis.computeLineDistances(); scene.add(axis);
const clip = new THREE.Plane(new THREE.Vector3(-1, 0, 0), 0);
dl.castShadow = true; dl.shadow.mapSize.set(2048, 2048); dl.shadow.camera.left = -140; dl.shadow.camera.right = 140; dl.shadow.camera.top = 160; dl.shadow.camera.bottom = -60; dl.shadow.camera.far = 600; dl.shadow.bias = -0.0004; dl.shadow.radius = 4;
const pmrem = new THREE.PMREMGenerator(renderer), envTex = pmrem.fromScene(new THREE.RoomEnvironment(), 0.04).texture;
const floor = new THREE.Mesh(new THREE.CircleGeometry(260, 64), new THREE.MeshStandardMaterial({ color: 0x141a24, roughness: 0.5, metalness: 0.1 }));
floor.rotation.x = -Math.PI / 2; floor.position.y = -0.05; floor.receiveShadow = true; scene.add(floor);

const OFF = { "1": -0.5, "2": 0.4, "Ø40 #1": 1.0, "5": 1.35, "Ø40 #2": 1.7, "3": 2.6, "Ø30 #1": 3.4, "6": 3.8, "Ø30 #2": 4.2, "4": 5.2 };
const offOf = n => { for (const k in OFF) if (n.startsWith(k)) return OFF[k]; return 0; };
function smoothNormals(pos) {      // normales lissees par angle de pli (40 deg) sur le maillage non indexe
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
  else if (glass) m = new THREE.MeshPhysicalMaterial({ color: c.name.includes("Ø40") ? 0xcfe8ff : 0xffe9cf, metalness: 0, roughness: 0.03, transmission: 0.65, thickness: 7, ior: 1.52, clearcoat: 1, clearcoatRoughness: 0.02, envMapIntensity: 1.6, side: THREE.DoubleSide });
  else { const f = $("fil").value, a = f === "code" ? [c.color, 0.5, 0.05] : FIL[f]; m = new THREE.MeshStandardMaterial({ color: a[0], roughness: a[1], metalness: a[2], envMapIntensity: 0.9, side: THREE.DoubleSide }); }
  p.mesh.material = m; p.mesh.castShadow = real && !glass; p.mesh.receiveShadow = real && !glass;
}
function applyLook() {
  const real = $("real").checked;
  scene.environment = real ? envTex : null; renderer.toneMapping = real ? THREE.ACESFilmicToneMapping : THREE.NoToneMapping; renderer.toneMappingExposure = 0.8;
  grid.visible = !real; axis.visible = !real; floor.visible = real; renderer.setClearColor(real ? 0x1b2330 : 0x10151c);
  scene.children.forEach(o => { if (o.isHemisphereLight) o.intensity = real ? 0.25 : 0.95; });
  parts.forEach(look); applyScene();
}
const parts = [];
DATA.comps.forEach(c => {
  const g = new THREE.BufferGeometry(); const pa = dec(c.pos); g.setAttribute("position", new THREE.BufferAttribute(pa, 3)); g.setAttribute("normal", new THREE.BufferAttribute(smoothNormals(pa), 3));
  const glass = c.kind === "glass";
  const mesh = new THREE.Mesh(g, new THREE.MeshBasicMaterial()); scene.add(mesh); parts.push({ c, mesh, glass, off: offOf(c.name), on: true });
});
$("parts").innerHTML = parts.map((p, i) => `<label><input type="checkbox" data-i="${i}" checked><i style="background:#${p.c.color.toString(16).padStart(6, "0")}"></i>${p.c.name}</label>`).join("");
$("parts").addEventListener("change", e => { const p = parts[+e.target.dataset.i]; if (p) p.mesh.visible = e.target.checked; });
function applyScene() {
  const e = +$("ex").value, op = +$("op").value, cut = $("cut").checked;
  $("exo").textContent = e; $("opo").textContent = op;
  const real = $("real").checked;
  parts.forEach(p => { p.mesh.position.y = p.off * e; p.mesh.material.clippingPlanes = cut ? [clip] : []; if (p.glass) { if (real) p.mesh.material.transmission = 1 - op; else p.mesh.material.opacity = op; } });
  drawRays();
}

// ---------- optique ----------
const SL = [["f40", "Focale Ø40 (mm)", 60, 250, 1], ["f30", "Focale Ø30 (mm)", 40, 200, 1], ["a30", "Ouverture utile œil (mm)", 25, 37, 0.5],
  ["a40", "Ouverture utile Ø40 (mm)", 30, 39, 0.5], ["gap", "Air entre groupes (mm)", 0.5, 15, 0.5],
  ["pupil", "Pupille de sortie (mm)", 1, 7, 0.5], ["er", "Dégagement imposé (0 = libre)", 0, 35, 1]];
const V = { f40: 160, f30: 110, a30: 29, a40: 37, gap: 1.5, pupil: 4, er: 0 }, FL = { on: false, f: 250 };
$("sl").innerHTML = SL.map(s => `<div class="row"><span>${s[1]}</span><input type="range" id="s_${s[0]}" min="${s[2]}" max="${s[3]}" step="${s[4]}" value="${V[s[0]]}"><output id="o_${s[0]}"></output></div>`).join("");
$("flrow").innerHTML = `<div class="row"><span>Focale lentille de champ</span><input type="range" id="s_flf" min="80" max="600" step="10" value="250"><output id="o_flf"></output></div>`;
const P = () => ({ f40: V.f40, f30: V.f30, a30: V.a30, a40: V.a40, gap: V.gap, pupil: V.pupil, erOverride: V.er, quad40: $("q40").checked, groups: custOn() ? groupsParam() : null, t40: DATA.stack.t40, t30: DATA.stack.t30, airIn: DATA.stack.air_in, fl: { on: FL.on, f: FL.f, ap: 37, gapToG1: 2, t: 5 } });
const fmt = (n, d = 1) => n.toFixed(d);
// ----- mode libre : groupes de 2 achromats -----
const STOCK = { 30: "105,120,135,150", 40: "140,160,180,200", 50: "175,200,225,250" };
const GF = [[160, 160], [110, 110], [110, 110]];       // focales par groupe (a, b)
let GD = [40, 30];
const gStyle = "width:62px;background:#0f151d;color:var(--tx);border:1px solid var(--ln);border-radius:6px;padding:3px";
$("stock").innerHTML = [30, 40, 50].map(d => `<div class="row"><span>Ø${d}</span><input id="st${d}" value="${STOCK[d]}" style="grid-column:2/4;${gStyle};width:100%"></div>`).join("");
function drawGroups() {
  $("grows").innerHTML = GD.map((d, i) => `<div class="row"><span>${tr("Groupe", "Group")} ${i + 1} · Ø${d}</span><div style="grid-column:2/4;display:flex;gap:6px;align-items:center">f1 <input type="number" class="gf" data-i="${i}" data-k="0" min="30" max="600" value="${GF[i][0]}" style="${gStyle}"> f2 <input type="number" class="gf" data-i="${i}" data-k="1" min="30" max="600" value="${GF[i][1]}" style="${gStyle}"> mm</div></div>`).join("");
  document.querySelectorAll(".gf").forEach(e => e.addEventListener("input", () => { GF[+e.dataset.i][+e.dataset.k] = Math.max(30, +e.value || 30); update(); }));
}
const custOn = () => $("cust").checked;
const groupsParam = () => GD.map((d, i) => ({ d, f: [GF[i][0], GF[i][1]] }));

function drawCurve(r) {
  const c = $("cur"), g = c.getContext("2d"), W = c.width, H = c.height, ml = 34, mb = 22, mt = 10, mr = 8;
  g.clearRect(0, 0, W, H); g.font = "11px system-ui"; g.fillStyle = "#8fa0b5"; g.strokeStyle = "#2a3544";
  const X = a => ml + a / 90 * (W - ml - mr), Y = f => H - mb - f * (H - mb - mt);
  for (let a = 0; a <= 90; a += 15) { g.beginPath(); g.moveTo(X(a), mt); g.lineTo(X(a), H - mb); g.stroke(); g.fillText(a + "°", X(a) - 8, H - 7); }
  [0, 0.5, 1].forEach(f => { g.beginPath(); g.moveTo(ml, Y(f)); g.lineTo(W - mr, Y(f)); g.stroke(); g.fillText(Math.round(f * 100) + "%", 2, Y(f) + 4); });
  g.beginPath(); r.curve.forEach((q, i) => { const x = X(2 * q.deg), y = Y(q.frac); i ? g.lineTo(x, y) : g.moveTo(x, y); });
  g.strokeStyle = "#4aa3ff"; g.lineWidth = 2; g.stroke(); g.lineWidth = 1;
  g.fillStyle = "#5ed39a"; g.fillRect(X(r.afov100) - 1, mt, 2, H - mb - mt); g.fillStyle = "#ffb454"; g.fillRect(X(r.afov50) - 1, mt, 2, H - mb - mt);
  g.fillStyle = "#8fa0b5"; g.fillText(tr("éclairement du bord (selon le champ apparent)", "edge illumination (vs apparent field)"), ml + 6, mt + 10);
}
let rayGroup = null, last = null;
function drawRays() {
  if (rayGroup) { scene.remove(rayGroup); rayGroup = null; }
  if (!$("rays").checked || !last || +$("ex").value > 0 || custOn()) return;   // en éclaté, les rayons ne suivraient pas les pièces
  const r = last, sys = r.sys, th = +$("ang").value * Math.PI / 180, s_e = Math.tan(th);
  const l1 = sys.L.find(l => l.name === "Ø40 #1" || l.name === "lentille de champ"), zl = sys.L.find(l => l.name === "Ø40 #1");
  const shift = DATA.stack.z40a - zl.z, e = +$("ex").value;
  rayGroup = new THREE.Group();
  [[0, 0xff5555], [sys.p.pupil / 2, 0xffb454], [-sys.p.pupil / 2, 0xffb454]].forEach(([yp, col]) => {
    const t = Optics.backTrace(sys, yp, s_e, r.zp), pts = [];
    const f0 = sys.L[0], yF = t.y_first - t.s_first * (f0.z - r.fo.zFocus);
    pts.push(new THREE.Vector3(yF, shift + r.fo.zFocus, 0));
    t.pts.forEach(p => pts.push(new THREE.Vector3(p.y, shift + p.z, 0)));
    rayGroup.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(pts), new THREE.LineBasicMaterial({ color: col })));
  });
  const ring = (z, rad, col) => { const m = new THREE.Mesh(new THREE.RingGeometry(rad - 0.4, rad, 48), new THREE.MeshBasicMaterial({ color: col, side: THREE.DoubleSide })); m.rotation.x = -Math.PI / 2; m.position.y = shift + z; return m; };
  rayGroup.add(ring(r.fo.zFocus, 23, 0x5ed39a));                       // plan de champ (diaphragme Ø46)
  rayGroup.add(ring(r.zp, 2.2 + 0 * sys.p.pupil, 0xffffff));           // point de l'oeil
  if (sys.p.fl && sys.L[0].name === "lentille de champ") rayGroup.add(ring(sys.L[0].z, 18.5, 0xffd24a));
  scene.add(rayGroup);
}
function update() {
  SL.forEach(s => { V[s[0]] = +$("s_" + s[0]).value; $("o_" + s[0]).textContent = s[0] === "er" && !V.er ? tr("libre", "free") : V[s[0]]; });
  FL.on = $("fl").checked; FL.f = +$("s_flf").value; $("o_flf").textContent = FL.f; $("s_flf").disabled = !FL.on;
  const r = Optics.analyze(P()); last = r;
  $("kpi").innerHTML = `<div><small>${tr("Focale oculaire", "Eyepiece focal length")}</small><b>${fmt(r.fo.EFL)} mm</b></div><div><small>${tr("Dégagement œil", "Eye relief")}</small><b>${fmt(r.ER)} mm</b></div>
   <div><small>${tr("Champ 100 %", "100 % field")}</small><b>${fmt(r.afov100, 0)}°</b></div><div><small>${tr("Champ 50 %", "50 % field")}</small><b>${fmt(r.afov50, 0)}°</b></div>`;
  $("lim").innerHTML = LANG === "en" ? `Field plane <b>${fmt(r.fo.ffd)} mm</b> in front of the 1st lens. 2" barrel ceiling: ${fmt(r.afovStop, 0)}°. Field-limiting element: <b>${limEn(r.limit)}</b>.` : `Plan de champ à <b>${fmt(r.fo.ffd)} mm</b> devant la 1re lentille. Plafond du fourreau 2" : ${fmt(r.afovStop, 0)}°. Élément qui limite le champ : <b>${r.limit || "-"}</b>.`;
  drawCurve(r); if (!custOn()) table(); else $("tab").innerHTML = tr("<tr><td>Tableau des pistes : disponible en mode Ø40 + Ø30.</td></tr>", "<tr><td>Options table: available in Ø40 + Ø30 mode.</td></tr>"); drawRays();
}
function table() {
  const b = P(), rows = [[tr("Base (vos valeurs)", "Base (your values)"), {}], [tr("Œil Ø33 utile", "Eye clear aperture Ø33"), { a30: 33 }], [tr("Œil Ø37 utile", "Eye clear aperture Ø37"), { a30: 37 }],
    [tr("Dégagement 20 mm", "Eye relief 20 mm"), { erOverride: 20 }], [tr("Dégagement 15 mm", "Eye relief 15 mm"), { erOverride: 15 }],
    [tr("Lentille de champ f 250", "Field lens f 250"), { fl: { on: true, f: 250, ap: 37, gapToG1: 2, t: 5 } }], [tr("Lentille de champ f 150", "Field lens f 150"), { fl: { on: true, f: 150, ap: 37, gapToG1: 2, t: 5 } }],
    [tr("Champ f 250 + œil Ø33", "Field f 250 + eye Ø33"), { a30: 33, fl: { on: true, f: 250, ap: 37, gapToG1: 2, t: 5 } }],
    [tr("Champ f 250 + œil Ø33 + dégag. 20", "Field f 250 + eye Ø33 + relief 20"), { a30: 33, erOverride: 20, fl: { on: true, f: 250, ap: 37, gapToG1: 2, t: 5 } }],
    ["4 × Ø40", { quad40: true }]];
  let base = null, h = `<tr><th>${tr("Variante", "Variant")}</th><th>F</th><th>${tr("Dégag.", "Relief")}</th><th>100 %</th><th>50 %</th><th>${tr("Gain", "Gain")}</th></tr>`;
  rows.forEach(([n, o], i) => {
    const q = Object.assign({}, b, o), r = Optics.analyze(q); if (i === 0) base = r;
    const d = r.afov100 - base.afov100;
    h += `<tr class="${i ? "" : "b"}"><td>${n}</td><td>${fmt(r.fo.EFL)}</td><td>${fmt(r.ER, 0)}</td><td>${fmt(r.afov100, 0)}°</td><td>${fmt(r.afov50, 0)}°</td><td class="${d > 0 ? "g" : d < 0 ? "r" : ""}">${i ? (d > 0 ? "+" : "") + fmt(d, 0) + "°" : "-"}</td></tr>`;
  });
  $("tab").innerHTML = h;
}
["ex", "op", "cut", "rays", "ang"].forEach(id => $(id).addEventListener("input", () => { $("ango").textContent = $("ang").value; applyScene(); }));
$("ango").textContent = $("ang").value;
SL.forEach(s => $("s_" + s[0]).addEventListener("input", () => { update(); }));
["fl", "q40", "s_flf"].forEach(id => $(id).addEventListener("input", update));
function applyCombo(f40, f30, gap, quad) {
  [["f40", f40], ["f30", f30], ["gap", gap]].forEach(([k, v]) => { $("s_" + k).value = v; });
  $("q40").checked = !!quad; update();
}
$("pre").addEventListener("input", () => { const v = $("pre").value; if (v) { const a = v.split(",").map(Number); applyCombo(a[0], a[1], a[2], a[3]); } });
["s_cap", "s_ermin"].forEach(id => $(id).addEventListener("input", () => { $("o_" + id.slice(2)).textContent = $(id).value; }));
$("cust").addEventListener("input", () => { $("custbox").style.display = custOn() ? "" : "none"; drawGroups(); update(); });
$("arch").addEventListener("input", () => { GD = $("arch").value.split(",").map(Number); drawGroups(); update(); });
function searchCustom(cap, ermin) {
  const stock = d => $("st" + d).value.split(",").map(Number).filter(x => x >= 30), out = [];
  const pairs = d => { const s = stock(d), r = []; s.forEach(a => s.forEach(b => r.push([a, b]))); return r; };
  const P0 = P(), lists = GD.map(pairs), gaps = [1.5, 6, 12];
  const rec = (i, cur) => {
    if (i === GD.length) { for (const gap of gaps) { const r = Optics.analyze(Object.assign({}, P0, { gap, erOverride: 0, groups: GD.map((d, k) => ({ d, f: cur[k] })) }));
      if (r.afov50 <= cap && r.ER >= ermin && r.fo.EFL >= 12) out.push({ cur: cur.slice(), gap, r }); } return; }
    for (const pr of lists[i]) { cur[i] = pr; rec(i + 1, cur); }
  };
  rec(0, []);
  out.sort((a, c) => c.r.afov100 - a.r.afov100 || c.r.ER - a.r.ER);
  let h = `<tr><th>${tr("Lentilles (f1/f2 par groupe)", "Lenses (f1/f2 per group)")}</th><th>${tr("Écart", "Gap")}</th><th>F</th><th>${tr("Dégag.", "Relief")}</th><th>100 %</th><th>50 %</th></tr>`;
  out.slice(0, 8).forEach(o => { h += `<tr class="pick" style="cursor:pointer" data-c='${JSON.stringify({ f: o.cur, g: o.gap })}'><td>${o.cur.map((p, k) => "Ø" + GD[k] + " " + p[0] + "/" + p[1]).join(" · ")}</td><td>${o.gap}</td><td>${fmt(o.r.fo.EFL)}</td><td>${fmt(o.r.ER, 0)}</td><td>${fmt(o.r.afov100, 0)}°</td><td>${fmt(o.r.afov50, 0)}°</td></tr>`; });
  $("best").innerHTML = out.length ? h : tr("<tr><td>Aucune combinaison avec ce stock : relâchez le dégagement min ou le champ max, ou ajoutez des focales.</td></tr>", "<tr><td>No combination with this stock: relax the min eye relief or the max field, or add focal lengths.</td></tr>");
  document.querySelectorAll("#best .pick").forEach(tr => tr.addEventListener("click", () => { const c = JSON.parse(tr.dataset.c); c.f.forEach((p, k) => { GF[k] = p.slice(); }); $("s_gap").value = c.g; drawGroups(); update(); }));
}
$("srch").addEventListener("click", () => {
  if (custOn()) { const cap = +$("s_cap").value, ermin = +$("s_ermin").value; $("best").innerHTML = tr("<tr><td>Calcul…</td></tr>", "<tr><td>Calculating…</td></tr>"); setTimeout(() => searchCustom(cap, ermin), 30); return; }
  const cap = +$("s_cap").value, ermin = +$("s_ermin").value, b = P(), out = [];
  $("best").innerHTML = tr("<tr><td>Calcul…</td></tr>", "<tr><td>Calculating…</td></tr>");
  setTimeout(() => {
    for (const quad of [false, true]) for (let f40 = 120; f40 <= 220; f40 += 10) for (let f30 = quad ? f40 : 90; f30 <= (quad ? f40 : 170); f30 += 10) for (const gap of [1.5, 5, 10, 15]) {
      const r = Optics.analyze(Object.assign({}, b, { quad40: quad, f40, f30: quad ? f40 : f30, gap, erOverride: 0 }));
      if (r.afov50 <= cap && r.ER >= ermin && r.fo.EFL >= 12) out.push({ quad, f40, f30: quad ? f40 : f30, gap, r });
    }
    out.sort((a, c) => c.r.afov100 - a.r.afov100 || c.r.ER - a.r.ER);
    let h = `<tr><th>${tr("Lentilles", "Lenses")}</th><th>${tr("Écart", "Gap")}</th><th>F</th><th>${tr("Dégag.", "Relief")}</th><th>100 %</th><th>50 %</th></tr>`;
    out.slice(0, 8).forEach(o => { h += `<tr class="pick" style="cursor:pointer" data-c="${o.f40},${o.f30},${o.gap},${o.quad ? 1 : 0}"><td>${o.quad ? "4×Ø40 f" + o.f40 : "Ø40 f" + o.f40 + " + Ø30 f" + o.f30}</td><td>${o.gap}</td><td>${fmt(o.r.fo.EFL)}</td><td>${fmt(o.r.ER, 0)}</td><td>${fmt(o.r.afov100, 0)}°</td><td>${fmt(o.r.afov50, 0)}°</td></tr>`; });
    $("best").innerHTML = out.length ? h : tr("<tr><td>Aucune combinaison : relâchez le dégagement min ou le champ max.</td></tr>", "<tr><td>No combination: relax the min eye relief or the max field.</td></tr>");
    document.querySelectorAll("#best .pick").forEach(tr => tr.addEventListener("click", () => { const a = tr.dataset.c.split(",").map(Number); applyCombo(a[0], a[1], a[2], a[3]); }));
  }, 30);
});
$("real").addEventListener("input", applyLook); $("fil").addEventListener("input", applyLook);
const VUES = { face: [190, 110, 210, 0, 50, 0], oeil: [70, 210, 95, 0, 80, 0], tele: [90, -70, 150, 0, 55, 0], profil: [260, 50, 0, 0, 50, 0] };
document.querySelectorAll(".vb[data-v]").forEach(b => b.addEventListener("click", () => { const v = VUES[b.dataset.v]; cam.position.set(v[0], v[1], v[2]); ctl.target.set(v[3], v[4], v[5]); ctl.update(); }));
function resize() { const v = $("view"); renderer.setSize(v.clientWidth, v.clientHeight, false); cam.aspect = v.clientWidth / v.clientHeight; cam.updateProjectionMatrix(); }
addEventListener("resize", resize); drawGroups(); resize(); update(); applyLook();
(function loop() {
  if (!window.__errs || (window.__fr = (window.__fr || 0) + 1) < 4) requestAnimationFrame(loop);   // mode test headless : 4 images max
  ctl.update(); floor.visible = $("real").checked && cam.position.y > 0;
  if ($("cut").checked) {   // le plan de coupe suit la caméra : on voit toujours l'intérieur de la moitié éloignée
    const dx = cam.position.x, dz = cam.position.z, n = Math.hypot(dx, dz) || 1;
    clip.normal.set(-dx / n, 0, -dz / n); clip.constant = 0;
  }
  renderer.render(scene, cam);
})();
const limEn = l => !l ? "-" : l === "lentille de champ" ? "field lens" : l.startsWith("diaphragme de champ") ? 'field stop (2" barrel)' : l;
function drawHud() { $("hud").innerHTML = LANG === "en"
  ? `<div class="chip">Base <b>Ø50.8</b> · pocket <b>Ø42.5 × 27</b></div><div class="chip">Cap <b>Ø61</b></div><div class="chip">Ring <b>Ø50 × 5.9</b></div><div class="chip">Total height <b>${DATA.stack.top.toFixed(0)} mm</b></div>`
  : `<div class="chip">Base <b>Ø50,8</b> · poche <b>Ø42,5 × 27</b></div><div class="chip">Coiffe <b>Ø61</b></div><div class="chip">Bague <b>Ø50 × 5,9</b></div><div class="chip">Hauteur totale <b>${DATA.stack.top.toFixed(0)} mm</b></div>`; }
function onLang() { drawHud(); drawGroups(); update(); $("best").innerHTML = ""; }
setLang(LANG);
</script></body></html>
