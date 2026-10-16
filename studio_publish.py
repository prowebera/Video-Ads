#!/usr/bin/env python3
"""Refreshes a project's website: studio.json -> studio.js (and index.html if missing).

Usage: studio_publish.py <project-folder> [--update-viewer]

The website is <project-folder>/index.html (plain HTML/CSS/JS, open it straight from the folder). It reads
studio.js, which this script writes from studio.json: it inlines every prompt_file into "prompt", and lists which
referenced files exist (with their change time, so the page shows new images). Run it after every change.
--update-viewer copies the skill's current viewer/index.html into the project.
"""
import json, os, shutil, sys

if len(sys.argv) < 2: sys.exit(__doc__)
ROOT = os.path.abspath(os.path.expanduser(sys.argv[1]))
VIEWER = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "viewer", "index.html")
src = os.path.join(ROOT, "studio.json")
if not os.path.isfile(src): sys.exit(f"No studio.json in {ROOT}")
p = json.load(open(src))

def inline(obj):
    f = obj.get("prompt_file")
    if f and os.path.isfile(os.path.join(ROOT, f)): obj["prompt"] = open(os.path.join(ROOT, f)).read().strip()

files = set()
for it in p.get("library", []): files.add(it.get("file"))
for s in p.get("shots", []):
    s.setdefault("frame_file", f"frames/f{s['id']}.png"); files.add(s["frame_file"]); inline(s)
p["_files"] = {f: int(os.path.getmtime(os.path.join(ROOT, f))) for f in files if f and os.path.isfile(os.path.join(ROOT, f))}

tmp = os.path.join(ROOT, ".studio.js.tmp")
with open(tmp, "w") as fh:
    fh.write("// Written by studio_publish.py from studio.json. Edit studio.json, not this file.\nwindow.STUDIO = ")
    json.dump(p, fh, ensure_ascii=False); fh.write(";\n")
os.replace(tmp, os.path.join(ROOT, "studio.js"))
page = os.path.join(ROOT, "index.html")
if "--update-viewer" in sys.argv or not os.path.exists(page): shutil.copy(VIEWER, page)
print(f"{ROOT}/index.html  ({len(p['_files'])} files found)")
