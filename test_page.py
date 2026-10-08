"""Test de la page dans Chrome headless (une vue a la fois, avec delai maximal) : erreurs JS + capture.
Usage : python test_page.py <dossier_sortie> [vue ...]   vues : reel_face reel_oeil reel_tele reel_coupe reel_eclate plat
Ne tue QUE les chrome lances ici (jamais le Chrome de l'utilisateur)."""
import os, subprocess, sys, re, time
here = os.path.dirname(os.path.abspath(__file__))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "_captures")
os.makedirs(out, exist_ok=True)
chrome = next(p for p in [r"C:\Program Files\Google\Chrome\Application\chrome.exe", r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"] if os.path.exists(p))
src = open(os.path.join(here, os.environ.get("PAGE", "oculaire_3D.html")), encoding="utf8").read()
VUES = {
    "reel_face": "view('face')", "reel_oeil": "view('oeil')", "reel_tele": "view('tele')",
    "reel_coupe": "document.getElementById('cut').checked=true;view('face')",
    "reel_eclate": "document.getElementById('ex').value=12;document.getElementById('ex').dispatchEvent(new Event('input'));view('face')",
    "multi": "var c=document.getElementById('cust');c.checked=true;c.dispatchEvent(new Event('input'));var a=document.getElementById('arch');a.value='50,40,30';a.dispatchEvent(new Event('input'));document.getElementById('srch').click();view('face')",
    "banc": "document.getElementById('af').click()",
    "bagues": "document.getElementById('cut').checked=true;view('profil')",
    "pick": "var c=document.getElementById('cust');c.checked=true;c.dispatchEvent(new Event('input'));document.getElementById('srch').click();setTimeout(function(){var r=document.querySelector('#best .pick');if(r)r.click()},2500);view('face')",
    "preset": "var p=document.getElementById('pre');p.value='140,105,12,0';p.dispatchEvent(new Event('input'));document.getElementById('srch').click();view('face')",
    "coupe2": "var c=document.getElementById('cut');c.checked=true;c.dispatchEvent(new Event('input'));var o=document.getElementById('op');o.value=0.15;o.dispatchEvent(new Event('input'));view('profil')",
    "banc2": "var d=document.getElementById('dia');d.value='50';d.dispatchEvent(new Event('input'));var f=document.getElementById('f');f.value=240;f.dispatchEvent(new Event('input'));document.getElementById('af').click();window.__kp=document.getElementById('kpi').innerText.replace(/\s+/g,' ')",
    "plat": "document.getElementById('real').checked=false;document.getElementById('real').dispatchEvent(new Event('input'));view('face')",
}
noms = sys.argv[2:] or list(VUES)
for name in noms:
    js = VUES[name]
    inj = ('<script>window.__errs=[];window.onerror=function(m,u,l){window.__errs.push(m+" @"+l)};'
           'function view(v){document.querySelector(\'.vb[data-v=\'+v+\']\').click()}'
           'window.addEventListener("load",function(){setTimeout(function(){' + js + ';setTimeout(function(){var p=document.createElement("pre");p.id="errs";p.textContent="ERRS:"+JSON.stringify(window.__errs)+"|KPI:"+(window.__kp||"")+"|BEST:"+(document.getElementById("best")||{innerText:""}).innerText.replace(/\s+/g," ").slice(0,330);document.body.appendChild(p)},4000)},400)})</script>')
    f = os.path.join(out, name + ".html")
    open(f, "w", encoding="utf8").write(src.replace("</body>", inj + "</body>", 1))
    prof = os.path.join(out, "profil_" + name)
    cmd = [chrome, "--headless=new", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--virtual-time-budget=15000",
           "--user-data-dir=" + prof, "--window-size=1200,720", "--screenshot=" + os.path.join(out, name + ".png"), "--dump-dom", "file:///" + f.replace("\\", "/")]
    t0 = time.time()
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, encoding="utf8", errors="replace")
    try:
        stdout, _ = p.communicate(timeout=75)
    except subprocess.TimeoutExpired:
        subprocess.run(["taskkill", "/PID", str(p.pid), "/T", "/F"], capture_output=True)
        print("%-12s DELAI DEPASSE (75 s) : rendu trop lourd ou boucle infinie" % name); continue
    m = re.search(r"ERRS:(\[.*?\].*?)</pre>", stdout or "")
    print("%-12s %5.1f s  erreurs JS : %s" % (name, time.time() - t0, m.group(1) if m else "page non terminee"))
