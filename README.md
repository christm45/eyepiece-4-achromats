# Oculaire 4 achromats

Oculaire de télescope imprimé en 3D : une paire d'achromats Ø40 mm et une paire Ø30 mm.

- `oculaire_3D.html` : vue 3D de l'oculaire et modèle optique du champ
- `banc_focale_3D.html` : banc de mesure de focale des lentilles
- `build_*.py`, `make_*.py`, `*_export.py` : génération des modèles et des pages (CadQuery)
- `mesure_focale.py`, `calcul_oculaire.py`, `optics.js` : calculs optiques
- `*.png` : captures des pièces et des cotes

Les deux pages 3D ont un bouton **FR / EN** (en haut à droite de la vue) ; la langue du navigateur est utilisée par défaut.
Regénérer les pages : `python make_html.py` et `python make_banc.py` (les gabarits sont `page_template.tpl`, `banc_page.tpl`, `i18n.js`).
