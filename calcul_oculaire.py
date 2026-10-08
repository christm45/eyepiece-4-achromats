"""Oculaire 2 groupes : paire Ø40 (champ, cote foyer) + paire Ø30 (oeil).
Modele paraxial, lentilles minces. Mettre les VRAIES focales mesurees ci-dessous."""
import math, sys
f40 = float(sys.argv[1]) if len(sys.argv) > 1 else 160.0   # focale d'un achromat Ø40 (mm)  -- ESTIMATION
f30 = float(sys.argv[2]) if len(sys.argv) > 2 else 110.0   # focale d'un achromat Ø30 (mm)  -- ESTIMATION
FS_MAX = 35.0                                              # diaphragme de champ max (ouverture utile Ø37)
F1, F2 = f40/2, f30/2                                      # paire quasi au contact : f/2
print(f"F1(paire Ø40)={F1:.0f} mm  F2(paire Ø30)={F2:.0f} mm  (focales estimees si non fournies)")
print(f"{'gap':>5} {'F oc.':>7} {'foyer avant':>12} {'dégagt oeil':>12} {'champ app.':>11}")
for d in range(10, int(F2)+1, 5):
    s = F1+F2-d
    F = F1*F2/s
    ffd = F1*(F2-d)/s          # foyer telescope en avant de la paire Ø40
    bfd = F2*(F1-d)/s          # dégagement oeil depuis la paire Ø30
    afov = 2*math.degrees(math.atan(FS_MAX/2/F))
    print(f"{d:5d} {F:7.1f} {ffd:12.1f} {bfd:12.1f} {afov:10.1f}°")
