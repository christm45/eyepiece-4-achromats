import os
here = os.path.dirname(os.path.abspath(__file__))
vendor = r"C:\Users\Bogdan\Desktop\fytsec ino skywatcher\fysetcE4\vendor"
rd = lambda p: open(p, encoding="utf8").read()
safe = lambda s: s.replace("</script", "<\\/script")
html = rd(os.path.join(here, "banc_page.tpl"))
html = (html.replace("__THREE__", safe(rd(os.path.join(vendor, "three.min.js"))))
            .replace("__ORBIT__", safe(rd(os.path.join(vendor, "OrbitControls.js"))))
            .replace("__ROOMENV__", safe(rd(os.path.join(vendor, "RoomEnvironment.js"))))
            .replace("__I18N__", safe(rd(os.path.join(here, "i18n.js"))))
            .replace("__DATA__", rd(os.path.join(here, "banc_meshes.json"))))
out = os.path.join(here, "banc_focale_3D.html")
open(out, "w", encoding="utf8").write(html)
print("ecrit banc_focale_3D.html : %.1f Mo" % (os.path.getsize(out) / 1e6))
