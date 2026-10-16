#!/usr/bin/env bash
# batch.sh sheets <jobs.tsv> [parallel=12]
# Runs the jobs written by the AI. Each tsv line:
#   sheets: id <TAB> prompt <TAB> out.png <TAB> ref ref ...
# (no empty fields: bash collapses consecutive tabs)
# Skips jobs whose output already exists, so a re-run only fills gaps. Bash arrays keep refs as separate args.
set -u; S="$(cd "$(dirname "$0")" && pwd)"; KIND="$1"; TSV="$2"; PAR="${3:-12}"
[ "$KIND" = sheets ] || { echo "only 'sheets' jobs are supported in this image-only version" >&2; exit 1; }
run_one() {
  local f refs; IFS=$'\t' read -r -a f <<<"$1"
  [ -f "${f[2]}" ] && { echo "${f[0]}: exists, skipped"; return; }
  read -r -a refs <<<"${f[3]:-}"
  "$S/kie_image.sh" "${f[1]}" "${f[2]}" 9:16 ${refs[@]+"${refs[@]}"}
}
i=0; while IFS= read -r line; do
  [ -z "$line" ] && continue
  ( sleep $(( i % PAR )); run_one "$line" ) &
  i=$((i+1)); while [ "$(jobs -rp | wc -l)" -ge "$PAR" ]; do sleep 2; done
done < "$TSV"; wait
