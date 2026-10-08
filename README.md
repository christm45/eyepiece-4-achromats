# Oculaire 4 achromats / 4-achromat eyepiece

Oculaire de télescope imprimé en 3D, fait de 4 achromats de jumelles : une paire Ø40 mm côté focuser 2" et une paire Ø30 mm côté œil.
3D-printed telescope eyepiece built from 4 binocular achromats: a Ø40 mm pair on the 2" focuser side and a Ø30 mm pair on the eye side.

Les pages 3D ont un bouton **FR / EN** (haut à droite de la vue). / The 3D pages have an **FR / EN** switch (top right of the view).

## Contenu / Contents

| Fichier / dossier | Rôle |
|---|---|
| `oculaire_3D.html` | Assemblage 3D (éclaté, coupe, rayons) + modèle optique du champ. Autonome : ouvrir dans un navigateur. |
| `banc_focale_3D.html`, `banc focale lentilles/` | Banc de mesure de la focale des achromats (STL, STEP, LISEZMOI, simulation 3D). |
| `stl_oculaire/` | Les 6 pièces imprimées de l'oculaire (STL). |
| `essais_oeilleton/` | Œilletons d'essai pour 24 / 20 / 17 / 14 mm de dégagement. |
| `build_oculaire.py` | Modèle CAO paramétrique (CadQuery). |
| `optics.js`, `test_optics.js` | Modèle optique paraxial (source unique de la page et des tests : `node test_optics.js`). |
| `mesure_focale.py` | Calcul de la focale à partir des lectures du banc. |
| `make_html.py`, `make_banc.py`, `mesh_export.py`, `export_stl.py`, `export_essais.py` | Régénération des pages, des maillages et des STL. |
| `vendor/` | three.js (licence MIT) intégré aux pages. |

## Précision : ce qui est mesuré, estimé, calculé

- **Lues sur les captures Onshape** (`*.png`) : Ø50,8 / Ø56 / Ø42,5 / Ø37 / profondeur 27 (base) ; Ø61 / Ø56,3 / Ø33 / Ø29 (coiffe) ; bague Ø50 / Ø44,3 / Ø32,5 / Ø28, hauteur 5,9.
- **Estimées, à ajuster** : épaisseurs des achromats (8 mm pour Ø40, 6 mm pour Ø30), longueur de la base, forme du dôme.
- **Focales : par défaut 160 / 110 mm = valeurs typiques de jumelles, PAS mesurées.** Mesurez les vôtres avec le banc, puis entrez-les dans la page : tous les chiffres se recalculent.
- **Modèle optique** : premier ordre, lentilles minces placées au milieu de leur épaisseur, ouvertures finies. Il donne la géométrie (vignettage, champ, dégagement, focale) mais **pas la netteté au bord** (astigmatisme, courbure de champ, coma, distorsion). Vérifié contre la formule de deux paires minces (F = F1·F2 / (F1 + F2 − d)).
- **Dégagement d'œil** : mesuré depuis la dernière surface de verre. **Plan de champ** : mesuré depuis la première surface de verre.
- Pupille de sortie prise à 4 mm et diaphragme de champ du fourreau 2" à Ø46 (valeurs nominales ; à adapter à votre fourreau).

Aucun résultat de ce dépôt n'a été validé sur le ciel : c'est un outil de conception, pas une garantie de performance.
