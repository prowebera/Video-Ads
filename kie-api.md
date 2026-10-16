# kie.ai API cheat sheet (image generation)

Base URL `https://api.kie.ai`, header `Authorization: Bearer $KIE_API_KEY`. Every response is
`{code, msg, data}` — check `code`, HTTP 200 doesn't mean success. The scripts read `KIE_API_KEY`
from the environment and fall back to an `export KIE_API_KEY=` line in `~/.zshrc` / `~/.bashrc`.

Model names change; confirm with `GET /api/v1/models?q=<name>` and `GET /api/v1/models/<model>/schema`
before relying on fields below. Discovery endpoints share a 1 request/second limit.

| Need | Call |
|------|------|
| Balance (credits; 200 credits ≈ $1) | `GET /api/v1/chat/credit` |
| Price text | `GET /api/v1/models/<model>/price` |
| Upload a local file (24 h lifetime) | `POST https://kieai.redpandaai.co/api/file-stream-upload` multipart `file`, `uploadPath` → `data.downloadUrl` |
| Start a job | `POST /api/v1/jobs/createTask` `{model, input:{…}}` → `data.taskId` |
| Poll | `GET /api/v1/jobs/recordInfo?taskId=…` → `data.state` waiting/queuing/generating/success/fail; result in `data.response.resultUrls[0]`; `failCode`/`failMsg` |

Results are deleted after 14 days — download immediately.

## Models used

**`gpt-image-2-text-to-image`** — `input: {prompt, aspect_ratio: "16:9"|"9:16"|…, resolution: "1K"|"2K"|"4K"}`.
~1–4 min per image, 10 credits at 2K.

**`gpt-image-2-image-to-image`** — same plus `input_urls: [url, …]` (required). Use for every
character/location/frame after the first sheet so the style stays locked.

**`seedream/5-pro-image-to-image`** (optional, via `KIE_IMAGE_MODEL=seedream/5-pro-image-to-image`) — 2K, needs refs.
Less conservative than GPT Image for glamour/lingerie shots, but worse at exact text.

This skill does not use video or music models.

## Failure codes seen

- `500 Internal Error` on images: often a brand/trademark name in the prompt or a filtered scene. Rewrite.
- `400 … input image 'content[0]' may contain sensitive information`: the reference/frame image was
  flagged (bedroom scene). Regenerate the image with a tamer action.
- `400 … url field cannot be empty`: a reference upload failed or wasn't passed (see the zsh gotcha).
- `Credits insufficient`: stop, report which images are missing and how much is needed to finish.
