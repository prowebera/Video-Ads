#!/usr/bin/env python3
"""Makes a new ad project folder with its subfolders and its own website.

Usage: new_project.py <parent-folder> <project-name> [--title "Nice Title"] [--aspect 9:16]

Creates <parent>/<project-name>/ with the folders below, a starter studio.json, studio.js and index.html.
Open index.html in a browser to review the project. Nothing is overwritten if the folder already exists.
"""
import json, os, re, subprocess, sys

a = sys.argv[1:]
if len(a) < 2: sys.exit(__doc__)
parent, name = os.path.expanduser(a[0]), re.sub(r"[^a-z0-9-]+", "-", a[1].lower()).strip("-")
title = a[a.index("--title") + 1] if "--title" in a else a[1]
aspect = a[a.index("--aspect") + 1] if "--aspect" in a else "9:16"
root = os.path.join(parent, name)

FOLDERS = ["assets", "frames", "prompts", "edit", "exports"]
os.makedirs(root, exist_ok=True)
for f in FOLDERS: os.makedirs(os.path.join(root, f), exist_ok=True)

sj = os.path.join(root, "studio.json")
if not os.path.exists(sj):
    starter = {"title": title, "type": "dialogue", "aspect": aspect,
               "review": {"step": "Brief", "tab": "brief", "message": "Check the brief, comment on anything that's wrong, then copy all comments into the chat."},
               "brief": {}, "story": {"pitches": [], "chosen": "", "beats": []}, "script": "", "style": "",
               "voices": [], "library": [], "shots": []}
    json.dump(starter, open(sj, "w"), indent=1, ensure_ascii=False)

subprocess.run([sys.executable, os.path.join(os.path.dirname(os.path.abspath(__file__)), "studio_publish.py"), root], check=True)
print("Folders:", ", ".join(FOLDERS))
