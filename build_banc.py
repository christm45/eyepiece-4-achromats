"""Banc de mesure de la focale des achromats (CadQuery).
Source LOINTAINE (>= 2 m, fenetre / lampe / LED au bout de la piece) : la lentille pose sur un chariot forme l'image sur un ecran
qui coulisse sur un rail gradue en mm. f = u*v/(u+v) avec u = distance source -> lentille (au metre ruban) et v = lentille -> ecran.
Repere : x le long du rail (source a -x, ecran a +x), y en travers, z vers le haut ; z = 0 : dessous du rail.
Dimensions a ajuster pour l'imprimante : JEU (jeu de glissement), RAIL_SEG (longueur d'un segment)."""
import cadquery as cq

# ---- rail -------------------------------------------------------------------
RAIL_W, RAIL_H = 24.0, 14.0
RAIL_SEG = 160.0           # longueur imprimee d'un segment (2 segments + queue d'aronde -> graduation 0..305 mm)
TONGUE = 15.0              # longueur de la queue d'aronde
JEU = 0.35                 # jeu de glissement des chariots / de l'assemblage
TICK_W, TICK_D = 0.55, 0.45
# ---- chariots ---------------------------------------------------------------
CAR_L, WALL, TOP = 40.0, 6.0, 5.0
CAR_Z = RAIL_H + JEU + TOP                      # dessus du chariot
Z_AX = 52.0                                     # hauteur de l'axe optique
T_POST = 14.0                                   # epaisseur du montant porte-lentille (x de -7 a +7)
X_IDX_LENS, X_IDX_SCREEN = 7.5, 8.0             # position de la fente d'index par rapport au plan de reference
# etages du logement de lentille, depuis la face avant du montant (x = -7) : (diametre, profondeur cumulee)
STEPS = ((50.4, 3.0), (40.4, 6.0), (30.4, 9.0))
BORE = 24.0
WIN_L, WIN_W = 10.0, 23.0                       # fenetre de lecture (le long du rail, en travers) : voit les traits (y -5..5) et les chiffres (y ~8)


def box(x0, x1, y0, y1, z0, z1):
    return cq.Workplane("XY").box(x1 - x0, y1 - y0, z1 - z0, centered=False).translate((x0, y0, z0))


def cx(d, x0, x1, y, z):
    """cylindre d'axe x, de x0 a x1, centre (y, z)"""
    return cq.Workplane("YZ").workplane(offset=x0).center(y, z).circle(d / 2).extrude(x1 - x0)


def cz(d, z0, z1, x, y):
    return cq.Workplane("XY").workplane(offset=z0).center(x, y).circle(d / 2).extrude(z1 - z0)


def graduations(x_a, x_b):
    """encoches de graduation tous les mm (courtes), 5 mm (moyennes), 10 mm (longues) + chiffres tous les 10 mm"""
    cut = None
    for mm in range(int(x_a), int(x_b) + 1):
        L = 10.0 if mm % 10 == 0 else 6.0 if mm % 5 == 0 else 3.0
        t = box(mm - TICK_W / 2, mm + TICK_W / 2, -5.0, -5.0 + L, RAIL_H - TICK_D, RAIL_H + 0.01)
        cut = t if cut is None else cut.union(t)
    return cut


def rail(seg):
    """seg 'A' : x 0..145 + queue d'aronde 145..160 ; seg 'B' : x 145..305 avec la mortaise a gauche."""
    if seg == "A":
        x0, x1 = 0.0, RAIL_SEG - TONGUE
        r = box(x0, x1, -RAIL_W / 2, RAIL_W / 2, 0, RAIL_H)
        tongue = (cq.Workplane("XY").polyline([(x1 - 0.5, -4.5), (x1 + TONGUE, -7.0), (x1 + TONGUE, 7.0), (x1 - 0.5, 4.5)]).close().extrude(RAIL_H))
        r = r.union(tongue)
        g = graduations(x0 + 1, x1)
        lo, hi = x0, x1
    else:
        x0 = RAIL_SEG - TONGUE
        x1 = x0 + RAIL_SEG
        r = box(x0, x1, -RAIL_W / 2, RAIL_W / 2, 0, RAIL_H)
        j = JEU
        sock = (cq.Workplane("XY").polyline([(x0 - 1, -4.5 - j), (x0 + TONGUE + j, -7.0 - j), (x0 + TONGUE + j, 7.0 + j), (x0 - 1, 4.5 + j)]).close().extrude(RAIL_H + 1))
        r = r.cut(sock)
        g = graduations(x0 + TONGUE + 1, x1 - 1)
        lo, hi = x0 + TONGUE, x1
    r = r.cut(g)
    for mm in range(int(lo // 10 + 1) * 10, int(hi), 10):         # chiffres tous les 10 mm (lisibles par la fenetre du chariot)
        try:
            txt = cq.Workplane("XY").workplane(offset=RAIL_H - TICK_D).center(mm, 8.2).text(str(mm), 3.2, TICK_D + 0.01, combine=False, halign="center")
            r = r.cut(txt)
        except Exception:
            pass
    return r


def chariot_base(index_x, x_left):
    """cavalier qui chevauche le rail, avec une fenetre de lecture au-dessus de la voie graduee : on voit les traits ET les chiffres
    (10 x 23 mm, de x_left a x_left + 10) et un fil repere de 0,8 mm (pont de 1,2 mm de haut) place exactement sur index_x"""
    w = RAIL_W / 2 + JEU
    blk = box(-CAR_L / 2, CAR_L / 2, -w - WALL, w + WALL, 0, CAR_Z)
    blk = blk.cut(box(-CAR_L / 2 - 1, CAR_L / 2 + 1, -w, w, -1, RAIL_H + JEU))
    blk = blk.cut(box(x_left, x_left + WIN_L, -WIN_W / 2, WIN_W / 2, RAIL_H, CAR_Z + 1))      # fenetre de lecture
    blk = blk.union(box(index_x - 0.4, index_x + 0.4, -WIN_W / 2 - 0.5, WIN_W / 2 + 0.5, CAR_Z - 1.2, CAR_Z))   # fil repere (sur l'axe de l'ancienne fente)
    return blk


def chariot_lentille():
    c = chariot_base(X_IDX_LENS, T_POST / 2 + 0.0)
    post = box(-T_POST / 2, T_POST / 2, -31.0, 31.0, CAR_Z - 0.5, Z_AX + 31.0)
    c = c.union(post)
    x_f = -T_POST / 2
    for d, depth in STEPS:                                           # logements etages Ø50 / Ø40 / Ø30
        c = c.cut(cx(d, x_f - 1, x_f + depth, 0, Z_AX))
    c = c.cut(cx(BORE, -T_POST, T_POST, 0, Z_AX))
    for xh in (-5.5, 0.5):                                           # 2 trous M3 (vis nylon) qui pincent la tranche de la lentille
        c = c.cut(cz(2.8, Z_AX, Z_AX + 32, xh, 0))
    c = c.cut(box(-T_POST / 2 - 1, -T_POST / 2 + 0.01, -1.5, 1.5, Z_AX + 22, Z_AX + 32))   # repere : tete de fleche sur le dessus avant (inutile a l'usage)
    return c


def chariot_ecran():
    c = chariot_base(X_IDX_SCREEN, 3.5)
    fr = box(-3.0, 3.0, -35.0, 35.0, CAR_Z - 0.5, Z_AX + 33.0)
    c = c.union(fr)
    c = c.cut(box(-4, 4, -28, 28, Z_AX - 28, Z_AX + 28))                   # fenetre 56 x 56
    c = c.cut(box(-0.55, 0.55, -30.0, 30.0, CAR_Z + 3.0, Z_AX + 34))       # fente pour calque / papier sulfurise (plan x = 0)
    return c


MASK_X = 3.55                                   # plan du masque (centre de la fente de 1,1 mm) par rapport a la face avant du montant de la source
LED_SEAT_X = -6.5                               # appui de la collerette de la LED 5 mm (corps de 8,6 mm : pointe a x = +2,1)
SRC_TOP = Z_AX + 16.0                           # haut du montant de la source


def support_source():
    """petit support autonome pour une LED 5 mm + masque (trou d'epingle dans du papier alu ou croix).
    La LED est sur l'axe optique (z = Z_AX, meme hauteur que la lentille : le support pose sur la table comme le rail). LED inseree par l'arriere,
    collerette contre l'epaulement, masque dans la fente de 1,1 mm devant la pointe, sortie evasee (la lumiere diverge apres le trou d'epingle)."""
    base = box(-35, 35, -35, 35, 0, 4)
    post = box(-7, 7, -20, 20, 4, SRC_TOP)
    s = base.union(post)
    s = s.cut(cx(6.2, -9, LED_SEAT_X, 0, Z_AX))                              # logement de la collerette (5,8 mm)
    s = s.cut(cx(5.3, LED_SEAT_X - 0.01, 2.8, 0, Z_AX))                      # corps de la LED 5 mm
    s = s.cut(cx(3.0, 2.7, 4.2, 0, Z_AX))                                    # passage jusqu'au masque
    s = s.cut(cq.Workplane("YZ").workplane(offset=4.1).center(0, Z_AX).circle(1.5).workplane(offset=2.95).circle(7.0).loft(combine=True))   # sortie evasee 3 -> 14 mm
    s = s.cut(box(MASK_X - 0.55, MASK_X + 0.55, -18, 18, 14, SRC_TOP + 1))   # fente du masque 1,1 mm
    s = s.cut(box(-8, -6.0, -1.0, 1.0, 4 - 1, Z_AX - 3.0))                   # rainure pour les fils de la LED (derriere)
    return s


def pieces():
    return [("1_rail_A", rail("A")), ("2_rail_B", rail("B")), ("3_chariot_lentille", chariot_lentille()),
            ("4_chariot_ecran", chariot_ecran()), ("5_support_source", support_source())]


if __name__ == "__main__":
    for n, s in pieces():
        bb = s.val().BoundingBox()
        print("%-20s %6.1f x %5.1f x %5.1f mm  vol %7.0f mm3 valide=%s" % (n, bb.xlen, bb.ylen, bb.zlen, s.val().Volume(), s.val().isValid()))
