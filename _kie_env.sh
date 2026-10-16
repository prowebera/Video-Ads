# Sourced by the kie_* scripts. Loads KIE_API_KEY and provides upload + poll helpers.
if [ -z "${KIE_API_KEY:-}" ]; then
  for rc in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
    # read the value only (no eval, so nothing else in the file can run)
    [ -f "$rc" ] && KIE_API_KEY=$(grep -E '^[[:space:]]*export[[:space:]]+KIE_API_KEY=' "$rc" | tail -1 | sed -E 's/^[[:space:]]*export[[:space:]]+KIE_API_KEY=//; s/^["'"'"']//; s/["'"'"'][[:space:]]*$//')
    [ -n "${KIE_API_KEY:-}" ] && break
  done
fi
[ -n "${KIE_API_KEY:-}" ] || { echo "KIE_API_KEY not set (create one at https://kie.ai/api-key)" >&2; exit 1; }

KIE_CACHE="${KIE_CACHE:-$PWD/.kie-upload-cache}"

# kie_upload <file> -> prints a URL. Reuses an upload of the same file version for 20 h (KIE keeps uploads 24 h).
kie_upload() {
  local f key now u
  f=$(cd "$(dirname "$1")" && pwd)/$(basename "$1"); touch "$KIE_CACHE"
  key="$f|$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f")"; now=$(date +%s)
  u=$(awk -F'\t' -v k="$key" -v n="$now" '$1==k && n-$2<72000 {print $3}' "$KIE_CACHE" | tail -1)
  if [ -z "$u" ]; then
    u=$(curl -s -X POST https://kieai.redpandaai.co/api/file-stream-upload -H "Authorization: Bearer $KIE_API_KEY" \
        -F "file=@$f" -F "uploadPath=images/story-image-ad" | jq -r '.data.downloadUrl // empty')
    [ -n "$u" ] || { echo "upload failed: $f" >&2; return 1; }
    printf '%s\t%s\t%s\n' "$key" "$now" "$u" >> "$KIE_CACHE"
  fi
  printf '%s' "$u"
}

# kie_run <request.json> <out-file> <label> [timeout-seconds] -> creates the task, polls, downloads.
kie_run() {
  local req="$1" out="$2" label="$3" timeout="${4:-1800}" tmp task deadline state
  tmp=$(mktemp)
  curl -s -X POST https://api.kie.ai/api/v1/jobs/createTask -H "Authorization: Bearer $KIE_API_KEY" \
       -H 'Content-Type: application/json' -d @"$req" -o "$tmp"
  if [ "$(jq -r .code "$tmp")" != 200 ]; then echo "$label: create failed: $(jq -r .msg "$tmp")"; rm -f "$tmp"; return 1; fi
  task=$(jq -r .data.taskId "$tmp"); deadline=$(( $(date +%s) + timeout ))
  while :; do
    if curl -sf -H "Authorization: Bearer $KIE_API_KEY" "https://api.kie.ai/api/v1/jobs/recordInfo?taskId=$task" -o "$tmp"; then
      state=$(jq -r .data.state "$tmp")
      case $state in
        success) curl -s "$(jq -r '.data.response.resultUrls[0]' "$tmp")" -o "$out"
                 echo "$label: saved $out ($(jq -r .data.creditsConsumed "$tmp") credits)"; break ;;
        fail)    echo "$label: FAIL $(jq -r '.data|"\(.failCode) \(.failMsg)"' "$tmp")"; rm -f "$tmp"; return 1 ;;
      esac
    fi
    [ "$(date +%s)" -ge "$deadline" ] && { echo "$label: timeout (task $task)"; rm -f "$tmp"; return 1; }
    sleep 8
  done
  rm -f "$tmp"
}
