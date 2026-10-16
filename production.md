# Production: look, shot sheets, frames

## Project layout

```
<ad>/
  assets/      character sheets (<id>-sheet.png), locations (loc-<id>.png), product refs
  frames/      one opening frame per shot (f<id>.png)
  prompts/     saved prompts (optional)
  exports/     optional exports
```

## Style

- Animated 3D "family feature film" style reads as a story, not as fake UGC, and keeps faces consistent.
- Don't put studio brand names (e.g. "Pixar") in prompts — GPT Image 2 on kie.ai failed with a
  generic 500 when one was used. Describe the look and reuse the same words in every prompt:
  "modern big-studio 3D animated family feature film (cartoon CGI), big expressive eyes,
  rounded soft features, smooth simplified skin, warm cinematic lighting".
- Vertical 9:16 for everything that ends up in the video.

## Character sheets

1. Lead first, text-to-image, 16:9 2K: front / 3/4 / side / back full body, three expression
   close-ups, plus detail panels for every story prop or condition state (gloves on; the condition at
   its worst). Show it and iterate (users ask for "more cartoony", "make the condition worse", age changes).
2. Every other character and every location: image-to-image with the approved lead sheet attached
   and "use the attached image ONLY as the art-style reference, do NOT draw the woman from it".
3. Name files `assets/<id>-sheet.png` and `assets/loc-<id>.png` so `studio.json` can point at them.
4. Check small details that betray the audience (a crucifix in a Protestant home, wrong ages, a ring
   that the story says doesn't fit).

## Shots: one opening frame per shot

Each shot gets one opening frame image, `frames/f<id>.png`, generated from its sheet prompt. The frame is for
planning and approval only. This skill stops at the frames; it does not generate video.

## Shot rules (write them into the frame prompt)

- **Line/dialogue lock:** every frame shows what its line literally says. Fix any frame that doesn't before generating.
- **Camera per frame:** say where the camera is (close-up of hands, over the shoulder, front at eye level,
  top-down, low, wide) and one clear physical action.
- **Variety:** no location twice in a row (callbacks excepted), no camera angle twice in a row.
- **Screens face the character.** Show screen content only over the shoulder or as a hand-and-phone
  close-up, with the real product screenshot attached and "copied exactly from the attached reference".
  Otherwise "the screen is never visible".
- **Anatomy and headcount:** "exactly two arms and two legs per person, normal-sized hands; each named
  character appears once" — the model duplicated people in group shots. Prefer simple standing
  or seated poses.

## Story rules — repeated in every prompt they affect

Anything the story depends on that the model could get wrong goes in `rules` (every prompt) or in the
frame action. Real failures this prevented:

- The skin condition jumped from the heroine to the church lady → rule: "ONLY Sarah ever has red skin;
  every other character always has normal, healthy hands."
- Gloves came and went mid-clip → state the prop state per frame.
- Healed scenes still showed one red hand → check healing reveals frame by frame.

## Content filters

Bedroom/intimacy shots get flagged (image "sensitive information"). Keep everyone fully
dressed, sitting rather than lying together, and express rejection with gestures (turning away, lamp off).
If a sheet is flagged, rewrite the action, don't retry the same prompt.

## Exact on-screen text and glamour shots

- Phone messages, name tags and similar: give the shot `\"text\": \"<exact words and where they go>\"`. The frame
  prompt then asks for exactly that text (GPT Image 2 spells it right, emoji included). Without `text`, frames ask for no text at all.
- GPT Image 2 makes lingerie modest. For a sexier (still no nudity) look, render that shot's frame with
  `KIE_IMAGE_MODEL=seedream/5-pro-image-to-image` (~$0.075 for 2K). Seedream draws a panel's quoted line as a
  subtitle, so `kie_image.sh` strips the quotes and forbids text for it — still check every Seedream frame for words.

## Shell gotcha

zsh does not word-split unquoted variables. `refs="a.png b.png"; script $refs` passes ONE argument and
silently sends no references (wasted money twice). Use bash, arrays, or the `batch.sh` runner.
