"""Nest one SVG's vector artwork inside another, so it isn't rasterized at low res.

Usage: python3 embed.py ART.svg TEMPLATE.svg OUT.svg
TEMPLATE contains a placeholder comment: <!--LOGO x=".." y=".." width=".." height=".."-->
"""
import re
import sys

art, template, out = sys.argv[1:]

inner = open(art).read()
inner = re.sub(r"<\?xml[^>]*>\s*", "", inner)
inner = re.sub(r"<!--.*?-->\s*", "", inner, flags=re.S)

# Swap the art's own width/height on its root <svg> for the placeholder's position and size.
root = re.search(r"<svg\b[^>]*>", inner).group(0)
new_root = re.sub(r'\s(width|height)="[^"]*"', "", root)

tpl = open(template).read()
m = re.search(r"<!--LOGO (.*?)-->", tpl)
new_root = new_root.replace("<svg", "<svg " + m.group(1), 1)
inner = inner.replace(root, new_root, 1)

open(out, "w").write(tpl.replace(m.group(0), inner))
