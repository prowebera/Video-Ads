# The project website (studio.json → studio.js → index.html)

Every project folder has its own review website:

```
<project>/index.html   the page (plain HTML/CSS/JS, copied from viewer/index.html). Open it from the folder.
<project>/studio.json  the data the AI keeps up to date
<project>/studio.js    written by scripts/studio_publish.py from studio.json. Never edit it by hand.
```

After any change: `python3 scripts/studio_publish.py <project>`. It inlines each `prompt_file` into `prompt`,
records which files exist (so new images show up), and writes `studio.js`. The open page re-reads
`studio.js` every 4 seconds. `--update-viewer` copies a newer `viewer/index.html` into the project.

The page is view-only. Viewers can leave comments on every item (kept in their own browser) and press
**Copy all comments**, which copies them as `Shot 09: …`, `Jack (fit): …`, ready to paste into the chat.

## studio.json

The `//` notes below are only for reading; real JSON has no comments. All paths are relative to the project folder. Anything not listed here is ignored by the page, so working data can live in the same file.

```json
{
  "title": "The Book",
  "type": "dialogue",
  "aspect": "9:16",
  "review": {"step": "Opening frames", "tab": "shots", "message": "One sentence on what to check."},

  "brief": {"product": "…", "audience": "…", "offer": ["…"], "format": "…", "off_limits": ["…"], "reference": "…"},
  "story": {
    "pitches": [{"id": "A", "title": "…", "logline": "…", "text": "optional notes"}],
    "chosen": "A",
    "beats": [{"name": "Humiliation", "share": "~10%", "text": "…"}]
  },
  "script": "Markdown. Dialogue script.",
  "style": "Style line added to every image prompt.",

  "voices": [{"key": "JACK", "label": "JACK", "desc": "Age, ethnicity, accent, pitch, attitude."}],

  "library": [
    {"key": "jack", "kind": "character", "name": "Jack (before)", "file": "assets/jack.png", "prompt": "…",
     "rule": "optional: added to every shot with this character (e.g. 'his face is never visible')"},
    {"key": "gym", "kind": "location", "name": "Gym", "file": "assets/gym.png", "prompt": "…",
     "extra": "optional: added to every shot in this place (e.g. 'almost pitch black, lit by red fire')"},
    {"key": "product", "kind": "prop", "name": "Product photo", "file": "assets/product.png"}
  ],

  "shots": [
    {"id": "01", "dur": 3, "refs": ["jack", "gym"], "voice": "JACK", "line": "Babe, it's time to go.",
     "frame": "What the opening frame shows.", "action": "What happens in the clip.",
     "frame_file": "frames/f01.png", "prompt_file": "prompts/frames/f01.txt"}
  ]
}
```

- `review.tab` is one of: brief, story, script, voices, character, location, prop, shots.
- `kind`: `character`, `location` and `prop` each get a tab. `frame` (or any other kind) can be used in shot `refs`, but gets no tab.
- `shots` are in story order.
- This skill does not use songs, parts or cuts.
