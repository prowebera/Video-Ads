# Dialogue ads: how to make them (image version)

What we learned making drama story ads. Read before writing voices or prompts. This version stops at
opening frames and prompts; it does not generate video or audio.

## Script

- Dialogue only, then stage directions in brackets. Every line is a full, simple sentence.
- Plan the daggers: a humiliating line at the start that comes back flipped at the end
  ("Babe, it's time to go" → fit Jack says "It's time to go"). Callbacks are what people share.
- The mentor says the product pitch, in character. Keep it true and short:
  what it does (one plain mechanism sentence), how you get it (steps), who checks you (a real doctor), the call to action.
- Price objection without a price or superlative: "But X costs a fortune." → "Not with <Brand>."
- Once the script is locked, keep the user's wording. Change order or add shots only when they ask.

## Voices

Each speaker gets one fixed description that is reused word for word in every frame prompt where they speak,
so the voice stays in range if the frames are later animated:

> "Jack is a white American man, 32 years old, with a soft Midwestern accent. His voice is mid-pitched, soft, tired and a
> little nasal. He speaks quietly and unsure, at a gentle pace."

Include age, ethnicity, accent, pitch, pace and attitude. A changed character (after the transformation) gets a second
description with the same base and a new attitude. A voice with a heavy effect (echo, growl) still comes out close enough.

## Sheets and sets

- Character sheet prompt: plain light-grey background, full body front / 3/4 / side, three head close-ups with expressions,
  same outfit in every view, plus the style line and "no text".
- The transformed version of a character: image-to-image from the first sheet ("the SAME man as the reference image … but now fit").
- **Empty sets come out photoreal or 3D even when the prompt says anime.** Make the set, then redraw it as flat 2D background art
  with the set AND a character sheet attached ("in the art style of the character sheet, NOT 3D, NOT photorealistic").
- Mood words matter: "dark" isn't enough for a villain's lair; "almost pitch black, lit only by low blood-red fire" works. Put that
  in the location's `extra` so every shot there gets it.
- A character the audience shouldn't see (a dark king): hood with pure black shadow and two glowing eyes, never a skull or teeth.
  Put "face is never visible" in the character's `rule`.
- Real product: use the real product photo as a prop reference and describe it ("small clear glass vial, dark green cap, green label
  with the white <Brand> wordmark, copied exactly from the reference").
- A family photo or any item that must match across shots: generate it once, then pass that image as a reference.

## Shots and frames

- One row per shot: id, seconds, refs (library keys), voice + line, opening frame text, action text. Ids can be like `31a` for inserts.
- Frame prompt = frame text + every `extra`/`rule` of its refs + the style line. Refs = the library files of its keys.
- Generate frames in batches of 6. Review them on the Shots tab. Typical fixes: wrong outfit for the scene, a person who
  shouldn't be there yet (spoils a reveal), a product that isn't the real one, a text item that's unreadable.
- For a match cut (eye close-up → same eye after the change), pass the first frame as a reference for the second.

This skill stops here. If you later want video, use the frames and prompts as the storyboard for your own video tool.
