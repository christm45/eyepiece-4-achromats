"""Oculaire a 4 achromats : paire Ø40 (cote focuser 2") + paire Ø30 (cote oeil).
Axe Z CAD : 0 = bas du fourreau (cote telescope), vers le haut = oeil.
Cotes lues sur les captures Onshape de l'utilisateur : Ø50,8 / Ø56 / Ø42,5 / Ø37 / profondeur 27 (base) ;
Ø61 / Ø56,3 / Ø33 / Ø29 (coiffe) ; bague Ø50 / Ø44,3 / Ø32,5 / Ø28, hauteur 5,9.
Cotes ESTIMEES (a ajuster) : longueurs, epaisseurs des lentilles, forme du dome."""
import cadquery as cq
import math

# ---- cotes lues -------------------------------------------------------------
D_TUBE, D_TETE = 50.8, 56.0
D_POCHE40, D_CLAIR40, PROF_POCHE = 42.5, 37.0, 27.0
D_COIFFE, D_JUPE = 61.0, 56.3
D_POCHE30, D_CLAIR30 = 33.0, 29.0
D_BAGUE, D_BAGUE_INT, D_BAGUE_MARCHE, D_BAGUE_CLAIR, H_BAGUE = 50.0, 44.3, 32.5, 28.0, 5.9
# ---- cotes estimees ---------------------------------------------------------
H_BASE = 73.0            # longueur totale de la base (mesuree sur la vue de cote)
H_TETE = 29.0            # hauteur de la tete Ø56
T40, T30 = 8.0, 6.0      # epaisseurs des achromats (A MESURER)
AIR_IN, GAP = 0.5, 1.5   # air dans une paire / entre les deux groupes
H_JUPE = 20.0            # recouvrement de la coiffe sur la tete
H_COIFFE = 34.0          # hauteur de la coiffe : son col s'arrete au ras du haut des Ø30 (la bague serre)
D_COU = 44.0             # col de la coiffe, sous la bague
H_SIEGE = GAP            # epaisseur de l'epaulement entre les deux groupes

H_BOURR, Z_BOURR = 0.4, 58.0         # cliquet d'emboitement : jonc de 0,4 mm sur la tete, gorge dans la jupe
N_FENTES, H_FENTE = 4, 9.0           # fentes de souplesse au bas de la jupe

Z_TETE0 = H_BASE - H_TETE            # 44
Z_POCHE0 = H_BASE - PROF_POCHE       # 46 : fond de la poche
# paire Ø40 collee au haut de la poche, cale en dessous
Z_G1_TOP = H_BASE
Z_L2_40 = (Z_G1_TOP - T40, Z_G1_TOP)                       # lentille 40 #2 (cote oeil)
Z_L1_40 = (Z_L2_40[0] - AIR_IN - T40, Z_L2_40[0] - AIR_IN)  # lentille 40 #1 (cote telescope)
Z_SIEGE30 = Z_G1_TOP + H_SIEGE                              # dessus de l'epaulement = assise Ø30
Z_L1_30 = (Z_SIEGE30, Z_SIEGE30 + T30)
Z_L2_30 = (Z_L1_30[1] + AIR_IN, Z_L1_30[1] + AIR_IN + T30)
Z_COIFFE0 = Z_TETE0 + H_TETE - H_JUPE                       # la jupe descend de H_JUPE sous le dessus de la tete
Z_COIFFE1 = Z_L2_30[1]                                      # col de la coiffe = haut de la 2e lentille Ø30


def cyl(d, z0, z1):
    return cq.Workplane("XY").workplane(offset=z0).circle(d / 2).extrude(z1 - z0)


def base():
    b = cyl(D_TUBE, 0, Z_TETE0 - 4)
    # raccord conique tube -> tete (vue de cote)
    cone = (cq.Workplane("XZ").polyline([(0, Z_TETE0 - 4), (D_TUBE / 2, Z_TETE0 - 4),
                                         (D_TETE / 2, Z_TETE0 + 3), (D_TETE / 2, H_BASE), (0, H_BASE)]).close()
            .revolve(360, (0, 0, 0), (0, 1, 0)))
    b = b.union(cone)
    # jonc de cliquet sur la tete (flancs a 45 deg : entree facile, retenue franche)
    jonc = (cq.Workplane("XZ").polyline([(D_TETE / 2 - 0.5, Z_BOURR - 1.2), (D_TETE / 2, Z_BOURR - 1.2),
                                         (D_TETE / 2 + H_BOURR, Z_BOURR - 0.8), (D_TETE / 2 + H_BOURR, Z_BOURR + 0.8),
                                         (D_TETE / 2, Z_BOURR + 1.2), (D_TETE / 2 - 0.5, Z_BOURR + 1.2)]).close()
            .revolve(360, (0, 0, 0), (0, 1, 0)))
    b = b.union(jonc)
    b = b.cut(cyl(D_CLAIR40, -1, H_BASE + 1))                # passage de lumiere Ø37
    b = b.cut(cyl(D_POCHE40, Z_POCHE0, H_BASE + 1))          # poche lentilles Ø42,5 x 27
    return b


def cale():
    """Entretoise sous la paire Ø40 : la remonte au ras du haut de la poche."""
    return cyl(D_POCHE40 - 0.3, Z_POCHE0, Z_L1_40[0]).cut(cyl(D_CLAIR40, Z_POCHE0 - 1, Z_L1_40[0] + 1))


def coiffe():
    r_col = D_COU / 2
    prof = [(D_JUPE / 2, Z_COIFFE0), (D_COIFFE / 2, Z_COIFFE0), (D_COIFFE / 2, Z_COIFFE0 + 14)]
    c = (cq.Workplane("XZ").moveTo(0, Z_COIFFE0).lineTo(D_COIFFE / 2, Z_COIFFE0).lineTo(D_COIFFE / 2, Z_G1_TOP + 2)       # le flanc reste plein jusqu'a 3 mm au-dessus du bord de la base :
         .threePointArc((D_COIFFE / 2 - 2.05, Z_G1_TOP + 6.25), (r_col + 1.5, Z_COIFFE1 - 6))   # jupe et dome ne font qu'une piece
         .lineTo(r_col, Z_COIFFE1 - 6).lineTo(r_col, Z_COIFFE1).lineTo(0, Z_COIFFE1).close()
         .revolve(360, (0, 0, 0), (0, 1, 0)))
    c = c.cut(cyl(D_JUPE, Z_COIFFE0 - 1, Z_G1_TOP))                 # jupe qui coiffe la tete Ø56
    r0, g = D_JUPE / 2, H_BOURR + 0.15                               # gorge : jeu de 0,15 mm autour du jonc
    gorge = (cq.Workplane("XZ").polyline([(r0 - 0.5, Z_BOURR - 1.5), (r0, Z_BOURR - 1.5), (r0 + g, Z_BOURR - 0.9),
                                          (r0 + g, Z_BOURR + 0.9), (r0, Z_BOURR + 1.5), (r0 - 0.5, Z_BOURR + 1.5)]).close()
             .revolve(360, (0, 0, 0), (0, 1, 0)))
    c = c.cut(gorge)
    for k in range(N_FENTES):                                        # fentes de souplesse : la jupe s'ecarte au clic
        f = cq.Workplane("XY").box(5.0, 1.0, H_FENTE + 1, centered=(False, True, False)).translate((r0 - 1.0, 0, Z_COIFFE0 - 1))
        c = c.cut(f.rotate((0, 0, 0), (0, 0, 1), k * 360.0 / N_FENTES + 45))
    c = c.cut(cyl(D_CLAIR30, Z_G1_TOP - 1, Z_SIEGE30 + 0.01))        # epaulement Ø29 entre les groupes
    c = c.cut(cyl(D_POCHE30, Z_SIEGE30, Z_COIFFE1 + 1))              # poche Ø33 pour les Ø30
    return c


def bague():
    z0 = Z_COIFFE1 - (H_BAGUE - 2.0)                                 # le rebord (2 mm) appuie sur la lentille
    b = cyl(D_BAGUE, z0, z0 + H_BAGUE)
    b = b.cut(cyl(D_BAGUE_INT, z0 - 1, z0 + H_BAGUE - 2.0))          # coiffe le col
    b = b.cut(cyl(D_BAGUE_CLAIR, z0 - 1, z0 + H_BAGUE + 1))          # passage Ø28
    return b


def bague_espace(d_poche, d_clair, l1, l2, d_lent, conv1, conv2):
    """Bague d'espacement entre les deux achromats d'une paire : vient se loger dans la poche, appuie sur le bord des
    deux lentilles (qui sont bombees l'une vers l'autre) et les maintient centrees. Decoupee au profil exact des
    lentilles : aucun jeu ni interference."""
    z0, z1 = l1[1] - 3.0, l2[0] + 3.0
    r = cyl(d_poche - 0.3, z0, z1).cut(cyl(d_clair, z0 - 1, z1 + 1))
    return r.cut(lentille(d_lent, *l1, conv1)).cut(lentille(d_lent, *l2, conv2))


def lentille(d, z0, z1, conv_vers_haut, sag_in=1.6, sag_out=0.7):
    """Achromat simplifie : cylindre bombe. Face convexe forte du cote de la paire voisine (type Plossl)."""
    t = z1 - z0
    r = d / 2
    s_in, s_out = sag_in, sag_out
    # profil : (rayon, z) -> arc bas et arc haut
    zb, zt = (z0, z1)
    # face basse et haute : si conv_vers_haut la face haute est la plus bombee
    s_bas, s_haut = (s_out, s_in) if conv_vers_haut else (s_in, s_out)
    # epaisseur z0..z1 = epaisseur au CENTRE : les sommets bombes restent dans cet intervalle, le bord est plus mince
    w = (cq.Workplane("XZ").moveTo(0, zb).threePointArc((r * 0.7071, zb + s_bas * 0.5), (r, zb + s_bas))
         .lineTo(r, zt - s_haut).threePointArc((r * 0.7071, zt - s_haut * 0.5), (0, zt)).close()
         .revolve(360, (0, 0, 0), (0, 1, 0)))
    return w


D_OEIL_INT, D_OEIL_EXT, D_OEIL_EMB, PROF_EMB, MARGE_CORNEE = 34.0, 52.0, 50.3, H_BAGUE, 3.0


def oeilleton(er):
    """Oeilleton d'essai : s'emboite sur la bague (Ø50) et amene le haut a `er` mm de la derniere SURFACE de la lentille Ø30
    (moins 3 mm : la pupille de l'oeil est ~3 mm derriere la cornee). Le cone du champ a 60 deg y passe largement :
    au haut de l'oeilleton le faisceau est deja etroit (rayon ~ distance a la pupille x rayon lentille / dégagement)."""
    z_bas = Z_COIFFE1 + 2.0 - H_BAGUE
    z_oeil = Z_L2_30[1] + er
    z_haut = z_oeil - MARGE_CORNEE
    body = cyl(D_OEIL_EXT, z_bas, z_haut)
    body = body.cut(cyl(D_OEIL_EMB, z_bas - 1, z_bas + PROF_EMB))
    body = body.cut(cyl(D_OEIL_INT, z_bas + PROF_EMB - 0.01, z_haut + 1))
    return body


def composants():
    # (nom, groupe, couleur, solide, type)
    return [
        {"name": "1 base basse Ø50,8 (poche Ø42,5 x 27)", "group": "imprime", "color": 0x1f6fb5, "shape": base(), "kind": "print", "dz": 0},
        {"name": "2 cale sous la paire Ø40", "group": "imprime", "color": 0xf08a24, "shape": cale(), "kind": "print", "dz": -1},
        {"name": "3 coiffe oeil (poche Ø33)", "group": "imprime", "color": 0x16a085, "shape": coiffe(), "kind": "print", "dz": 2},
        {"name": "4 bague de serrage cote oeil", "group": "imprime", "color": 0xc8323c, "shape": bague(), "kind": "print", "dz": 3},
        {"name": "5 bague d'espacement paire Ø40", "group": "imprime", "color": 0xe3b23c,
         "shape": bague_espace(D_POCHE40, D_CLAIR40, Z_L1_40, Z_L2_40, 40, True, False), "kind": "print", "dz": 0},
        {"name": "6 bague d'espacement paire Ø30", "group": "imprime", "color": 0xe3b23c,
         "shape": bague_espace(D_POCHE30, D_CLAIR30 - 1.0, Z_L1_30, Z_L2_30, 30, True, False), "kind": "print", "dz": 0},
        {"name": "Ø40 #1 achromat (cote telescope)", "group": "verre", "color": 0x9fd9ff, "shape": lentille(40, *Z_L1_40, True), "kind": "glass", "dz": -2},
        {"name": "Ø40 #2 achromat", "group": "verre", "color": 0x9fd9ff, "shape": lentille(40, *Z_L2_40, False), "kind": "glass", "dz": 0},
        {"name": "Ø30 #1 achromat", "group": "verre", "color": 0xbfe8ff, "shape": lentille(30, *Z_L1_30, True), "kind": "glass", "dz": 1},
        {"name": "Ø30 #2 achromat (cote oeil)", "group": "verre", "color": 0xbfe8ff, "shape": lentille(30, *Z_L2_30, False), "kind": "glass", "dz": 2},
    ]


def stack():
    """Positions optiques (centres des lentilles) pour la page : en mm depuis le bas du fourreau."""
    return {"z40a": sum(Z_L1_40) / 2, "z40b": sum(Z_L2_40) / 2, "z30a": sum(Z_L1_30) / 2, "z30b": sum(Z_L2_30) / 2,
            "base": H_BASE, "top": Z_COIFFE1 + 2.0, "tete0": Z_TETE0, "poche0": Z_POCHE0, "t40": T40, "t30": T30,
            "air_in": AIR_IN, "gap": GAP}


if __name__ == "__main__":
    for c in composants():
        bb = c["shape"].val().BoundingBox()
        print("%-40s vol %8.0f mm3  z %6.1f -> %6.1f  Ø%.1f" % (c["name"], c["shape"].val().Volume(), bb.zmin, bb.zmax, bb.xmax - bb.xmin))
    print(stack())
