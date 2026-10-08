"""Calcule la focale d'un achromat a partir des lectures sur le banc (voir 'banc focale lentilles/LISEZMOI.md').
Usage : python mesure_focale.py <Ø lentille : 30|40|50> <lecture chariot lentille mm> <lecture chariot ecran mm> <u mm> [epaisseur mm]
  u = distance source -> lentille mesuree au metre ruban (jusqu'au montant du chariot), en mm.  Ex. 3 m -> 3000.
Sans arguments : exemple chiffre."""
import sys

DIST_ARRIERE_INDEX = {50: 11.5, 40: 8.5, 30: 5.5}   # face arriere de la lentille -> fente d'index du chariot lentille (mm)
ECRAN_INDEX = 8.0                                    # plan du papier -> fente d'index du chariot ecran (mm)


def focale(d, r_lent, r_ecr, u, t=0.0):
    sommet = r_lent - DIST_ARRIERE_INDEX[d]          # position du sommet arriere de la lentille sur la regle
    bfd = (r_ecr - ECRAN_INDEX) - sommet             # sommet arriere -> ecran
    v = bfd + t / 2.0                                # ~ plan principal au milieu de l'epaisseur
    f = u * v / (u + v - 0.0) if u > 0 else v
    return bfd, v, f


if __name__ == "__main__":
    if len(sys.argv) < 5:
        print("Exemple : Ø40, lectures 60 et 225 mm, source a 3 m, epaisseur 8 mm")
        args = (40, 60.0, 225.0, 3000.0, 8.0)
    else:
        a = sys.argv[1:]
        args = (int(a[0]), float(a[1]), float(a[2]), float(a[3]), float(a[4]) if len(a) > 4 else 0.0)
    bfd, v, f = focale(*args)
    d, rl, re_, u, t = args
    print("Ø%d  lecture lentille %.1f  lecture ecran %.1f  u = %.0f mm  epaisseur %.1f mm" % (d, rl, re_, u, t))
    print("distance sommet arriere -> ecran (BFD) : %.1f mm" % bfd)
    print("distance plan principal -> ecran  v    : %.1f mm" % v)
    print("FOCALE  f = u*v/(u+v) = %.1f mm" % f)
    print("(erreur de lecture +-0,5 mm sur chaque lecture -> f a +-1 mm ; l'hypothese du plan principal au milieu ajoute au plus ~2 mm)")
