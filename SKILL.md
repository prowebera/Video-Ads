---
name: story-image-ad
description: Make drama-style story image ads end to end: brief, story, dialogue script, voices, character sheets, locations and props, shots and opening frames. Every project gets its own folder and its own review website (index.html) where the user reviews each step, comments and copies the comments back into the chat. Use this whenever someone wants a drama story ad, anime or cartoon story ad, testimonial-style skit, retargeting skit, "make a story ad like this video", or wants to turn a script into an animated story — even if they never say "VSL" or "Seedance". This skill covers image generation only; it does not generate video, audio songs or Suno music.
---

# Story Ad (image frames, dialogue)

One kind of ad: a short animated drama with spoken lines, built as a set of reviewable image frames
(character sheets, locations, props and one opening frame per shot). People watch a story to the end, and the
product shows up as the turning point of someone's life instead of as an ad.

## Step 0 — always ask first

1. **Which image tool is connected?** Use the image generation tool the user has connected in this chat
   (an MCP connector or app). If there is none, the bundled `scripts/kie_*.sh` can call kie.ai with the user's
   **own** `KIE_API_KEY` from their environment (see README). Never ask for a key in chat, never paste one into a
   file, never use anyone else's key.
2. **Existing project that has no `index.html` yet** (made before this website existed, or made by hand): give it one now.
   Write a `studio.json` from what's in the folder, then `python3 scripts/studio_publish.py <folder>`.
   Then tell the user to open the project's `index.html`.
3. New project: make the folder and its website:
   `python3 scripts/new_project.py <parent-folder> "<project name>" [--aspect 9:16]`
   It creates the subfolders, a starter `studio.json`, `studio.js` and `index.html`. Tell the user to open
   `index.html` from the project folder in their browser (double-click it). It's plain HTML, CSS and JS with no server.

## The review loop (every step)

The user reviews **every** step on the project website, not in the chat. After each step:

1. Write the results into `studio.json` (format: `references/studio.md`) and set `review` to the step,
   the tab to open and one sentence on what to check.
2. Run `python3 scripts/studio_publish.py <project-folder>`. The open page refreshes by itself within a few seconds.
3. Tell the user in one line: what's ready, which tab, what it cost so far.
4. Wait. The user writes comments on the page, presses **Copy all comments**, and pastes them into the chat.
   Fix only what they flagged, publish again, and repeat until they approve. Then move to the next step.

The website is view-only: no generate or edit buttons. All work happens in the chat.

## Money rules (read first)

Image generation costs the user real money, and they will be angry if it is wasted.

- Before every paid batch, state what will run, how many generations and the estimated cost, and get a clear yes.
  Check the balance first if the tool can (`scripts/kie_balance.sh` with kie.ai).
- Test one item before a full batch whenever a new look, model or prompt pattern is involved.
- Only generate what was asked for. No bonus takes, no "let me try again to fix a small thing" retries, no variants.
  If a result is off, show it, say what's wrong, and let the user decide. Fixing a defect the user flagged is fine.
- Run images in batches of about 6 at a time; bigger bursts hit rate limits ("call frequency too high") and fail.
- When the user says stop, stop launching jobs. Let jobs already running finish and report them.

Cost reference (kie.ai, verify with the price endpoint): GPT Image 2 ≈ $0.05 per 2K image (10 credits).
A typical ad ≈ 40 images (characters, locations, props and one opening frame per shot) ≈ $2.

## Rules for every ad

- **No text in visuals.** Write "no text, no letters, no logos, no signage" into image prompts. The user adds
  all captions, disclaimers and end cards. The only exception is exact text the user asks for in a shot (a name in a book, a phone message).
- **Simple full sentences** in dialogue (about grade 3). No fragment stacks.
- **Claims:** only what the brief allows. No prices unless given, no superlatives ("most affordable", "best"),
  no "FDA/clinically approved" for compounded or unapproved products, no cure claims, no fake testimonials.
  Rephrase to something true and keep the punch (e.g. "Not with <Brand>." instead of "the cheapest").
- **Copying a reference video:** take the structure and the beats, write your own lines. Don't copy a race-coded or
  hateful dynamic; flag Meta risks (sexual themes, body shaming, before/after bodies) once, and let the user decide.
- Faces of scary or supernatural characters can stay hidden (hood + glowing eyes): friendlier for ads, and no lip sync to get wrong.
- This skill does **not** generate video, audio songs or Suno music. It produces the image frames and prompts a user
  can take into their own editor or video tool.

## Steps 1–3 (all ads)

1. **Brief** → `brief` (product, audience, offer, format, off-limits claims, reference). Tab: Brief.
2. **Story** → pitch 2–3 ideas as `story.pitches`, the user picks one (`story.chosen`), then lock the beats
   with their runtime shares (`story.beats`). The user often wants it MORE dramatic than feels comfortable — go there. Tab: Story.
3. **Script** → dialogue-only script, every line a full sentence, with who says it and a short stage direction.
   Put it in `script` (Markdown). Expect many rounds; when the user edits wording, keep their wording. Tab: Script.

Then follow the image path below.

## Image ad path

Read `references/dialogue-ads.md` before writing voices or prompts and `references/production.md` before generating any
images. `references/kie-api.md` has the API details.

4. **Voices** → `voices`: one description per speaker (age, ethnicity, accent, pitch, attitude), pasted word for word
   into every frame prompt where they speak, so the voice stays in range. Tab: Voices.
5. **Characters** → `library` (kind `character`): lead sheet first (text-to-image), then the others; a changed version of a
   character (after the transformation) is made from the first sheet so the face matches. Tab: Characters.
6. **Locations and props** → `library` (kinds `location`, `prop`). Empty sets come out photoreal unless you redraw them
   with a character sheet attached as the style reference. The real product photo is a prop. Tab: Locations / Props.
7. **Shots and opening frames** → `shots`: one row per shot (lines, voice, refs, frame, action, seconds). One opening
   frame per shot from the sheets, `frames/f<id>.png`. Tab: Shots. Re-order or change shots only as the user asks.

Generate images with the connected image tool, or with `scripts/kie_image.sh`:
`scripts/kie_image.sh <prompt-file> <out.png> [aspect] [ref-image ...]`.
Run character sheets first, then locations/props, then frames in batches of about 6.

## References

- `references/dialogue-ads.md` — voices, sheets, sets, shots and frames.
- `references/production.md` — style, character sheets, sets, shot rules (image only).
- `references/kie-api.md` — kie.ai image API details.
- `references/studio.md` — `studio.json` format and the review website.
