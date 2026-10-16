#!/usr/bin/env bash
# kie_image.sh <prompt-file> <out.png> [aspect=16:9] [ref-image ...]
# GPT Image 2 at 2K. No refs -> text-to-image; refs -> image-to-image (refs are style/character references).
# KIE_IMAGE_MODEL=seedream/5-pro-image-to-image uses Seedream 5 Pro (2K, needs refs) instead: less conservative
# than GPT Image for glamour/lingerie shots, but worse at exact text.
set -u; . "$(dirname "$0")/_kie_env.sh"
P="$1"; OUT="$2"; AR="${3:-16:9}"; shift $(( $# >= 3 ? 3 : $# ))
urls="[]"; for f in "$@"; do u=$(kie_upload "$f") || exit 1; urls=$(jq -c --arg u "$u" '. + [$u]' <<<"$urls"); done
req=$(mktemp)
if [ "${KIE_IMAGE_MODEL:-}" = seedream/5-pro-image-to-image ]; then
  [ "$urls" = "[]" ] && { echo "seedream needs at least one reference image" >&2; exit 1; }
  # Seedream draws a quoted line as a subtitle: drop the ("...") quotes and forbid text.
  sed -E 's/ \(".*"\)$//' "$P" > "$req.prompt"; printf '%s\n' "Absolutely no text, subtitles, captions or words anywhere in the image." >> "$req.prompt"
  jq -n --rawfile p "$req.prompt" --arg ar "$AR" --argjson u "$urls" '{model:"seedream/5-pro-image-to-image",input:{prompt:$p,image_urls:$u,aspect_ratio:$ar,quality:"high",output_format:"png"}}' > "$req"; rm -f "$req.prompt"
elif [ "$urls" = "[]" ]; then
  jq -n --rawfile p "$P" --arg ar "$AR" '{model:"gpt-image-2-text-to-image",input:{prompt:$p,aspect_ratio:$ar,resolution:"2K"}}' > "$req"
else
  jq -n --rawfile p "$P" --arg ar "$AR" --argjson u "$urls" '{model:"gpt-image-2-image-to-image",input:{prompt:$p,input_urls:$u,aspect_ratio:$ar,resolution:"2K"}}' > "$req"
fi
mkdir -p "$(dirname "$OUT")"; kie_run "$req" "$OUT" "$(basename "$OUT")" 600; rc=$?; rm -f "$req"; exit $rc
